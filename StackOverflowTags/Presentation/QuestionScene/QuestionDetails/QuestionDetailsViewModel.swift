//
//  QuestionDetailsViewModel.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/26.
//

import Foundation

protocol QuestionDetailsViewModelDelegate: class {
    func showLoadingBodyAttributedText()
    func hideLoadingBodyAttributedText()
    func showLoadingForLoadImage()
    func hideLoadingForLoadImage()
    func setBodyAttributedText(attributedText: NSAttributedString)
    func setProfileImageData(data: Data)
}

final class QuestionDetailsViewModel {


    let title: String
    let body: String
    let tags: String
    let reputation: String
    let displayName: String
    let created: String

    private let ownerProfileUrl: URL?

    @Inject
    private var repository: QuestionRepository

    weak var delegate: QuestionDetailsViewModelDelegate?

    private static let dateFormatter: DateFormatter = DateFormatter()

    init(question: Question) {

        self.title = question.title
        self.body = question.body ?? ""
        self.displayName = question.owner?.displayName ?? ""
        self.created = QuestionDetailsViewModel.getCreatedAt(unixTime: question.createdAt)
        self.tags = QuestionDetailsViewModel.getTagsString(tags: question.tags)
        self.ownerProfileUrl = question.owner?.profileImage
        if let reputation = question.owner?.reputation {
            self.reputation = "\(reputation)"
        } else{
            self.reputation = ""
        }
    }

    private static func getTagsString(tags: [String]) -> String {
        if  let last = tags.last {
            let text = tags.reduce(into: "", { (result, tag) in
                result.append(tag != last ? "\(tag), " : "\(tag)")
            })
            return text
        }
        else{
            return ""
        }
    }

    private static func getCreatedAt(unixTime: Double) -> String {
        let askedString = "asked".localized
        let atString = "at".localized
        let epochTime = TimeInterval(unixTime)
        let date = Date(timeIntervalSince1970: epochTime)
        let day = QuestionDetailsViewModel.getFormattedDayString(from: date)
        let monthYear = QuestionDetailsViewModel.formatMonthYear(from: date)
        let time = QuestionDetailsViewModel.formatTime(from: date)
        return "\(askedString) \(day) \(monthYear) \(atString) \(time)"
    }

    private static func getFormattedDayString(from date: Date) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = Calendar.current.component(.day, from: date)
        return numberFormatter.string(from: day as NSNumber) ?? "\(day)"
    }

    private static func formatMonthYear(from date: Date) -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    private static func formatTime(from date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }

    func convertToAttributedText(plain: String) {
        delegate?.showLoadingBodyAttributedText()
        DispatchQueue.global(qos: .userInteractive).async {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                               .characterEncoding: String.Encoding.utf8.rawValue]
            if let data = plain.data(using: .unicode, allowLossyConversion: true),
               let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                self.setCovertedAttrString(attributedText: attrStr)
            }
            else{
                let attrStr = NSAttributedString(string: plain.html2AttributedString)
                self.setCovertedAttrString(attributedText: attrStr)
            }
        }
    }

    private func setCovertedAttrString(attributedText: NSAttributedString){
        DispatchQueue.main.async {
            self.delegate?.hideLoadingBodyAttributedText()
            self.delegate?.setBodyAttributedText(attributedText: attributedText)
        }
    }


    func loadOnwnerProfileImage(){
        guard let imageUrl = self.ownerProfileUrl else {
            return
        }
        loadImage(from: imageUrl)
    }

    private func loadImage(from url: URL){
        self.delegate?.showLoadingForLoadImage()
        repository.loadImage(from: url) { (result) in
            DispatchQueue.main.async {
                self.handleLoadImageResult(result: result)
            }
        }
    }

    private func handleLoadImageResult(result: Result<Data, ApiError>){
        self.delegate?.hideLoadingForLoadImage()
        switch result {
        case .success(let data):
            self.delegate?.setProfileImageData(data: data)
        case .failure(_):
            return
        }
    }
}
