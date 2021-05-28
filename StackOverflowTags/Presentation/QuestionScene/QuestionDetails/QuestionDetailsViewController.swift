//
//  QuestionDetailsViewController.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/26.
//

import UIKit
import WebKit

class QuestionDetailsViewController: QuestionBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerProfileImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var askedDateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var tagsView: UIView!

    private let viewModel: QuestionDetailsViewModel!
    private let xibName = "QuestionDetailsViewController"

    @Inject
    var bodyLoadingIndicator: LoadingIndicator

    @Inject
    var imageLoadingIndicator: LoadingIndicator

    init(viewModel: QuestionDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: xibName, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        configureViews()
    }

    private func configureViews(){
        navigationItem.title = "Question".localized
        tagsView.layer.borderWidth = 1
        tagsView.layer.borderColor = UIColor.mountainMist.cgColor
        setViewsValues()
    }

    private func setViewsValues(){
        titleLabel.text = viewModel.title.html2AttributedString
        ownerNameLabel.text = viewModel.displayName
        reputationLabel.text = viewModel.reputation
        askedDateLabel.text = viewModel.created
        bodyTextView.attributedText = nil
        tagsLabel.text = viewModel.tags
        viewModel.convertToAttributedText(plain: viewModel.body)
        viewModel.loadOnwnerProfileImage()
    }
}

extension QuestionDetailsViewController: QuestionDetailsViewModelDelegate {
    func showLoadingBodyAttributedText() {
        bodyLoadingIndicator.showLoadingIndicator(onView: bodyTextView)
    }

    func hideLoadingBodyAttributedText() {
        bodyLoadingIndicator.hideLoadingIndicator()
    }

    func showLoadingForLoadImage() {
        imageLoadingIndicator.showLoadingIndicator(onView: ownerProfileImageView)
    }

    func hideLoadingForLoadImage() {
        imageLoadingIndicator.hideLoadingIndicator()
    }

    func setBodyAttributedText(attributedText: NSAttributedString){
        bodyTextView.attributedText = attributedText
    }

    func setProfileImageData(data: Data) {
        ownerProfileImageView.image = UIImage(data: data)
    }
}
