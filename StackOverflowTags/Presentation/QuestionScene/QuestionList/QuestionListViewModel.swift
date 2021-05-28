//
//  QuestionListViewModel.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import Foundation

protocol QuestionListViewModelDelegate: class {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func noQuestionFound(message: String)
    func didLoadQuestions()
    func onApiError(message: String)
    func navigateToNextScreen(with viewModel: QuestionDetailsViewModel)
}

final class QuestionListViewModel {

    private weak var delegate: QuestionListViewModelDelegate?
    var items: [Question] = [Question]()
    var searchText: String?

    @Inject
    var repository: QuestionRepository

    init(delegate: QuestionListViewModelDelegate) {
        self.delegate = delegate
    }

    // MARK: - EVENTS
    func performQuery(){
        guard let searchText = searchText else {
            return
        }
        delegate?.showLoadingIndicator()
        getQuestions(with: searchText)
    }

    func didSelectItemAt(row: Int){
        let question = items[row]
        let viewModel = QuestionDetailsViewModel(question: question)
        self.delegate?.navigateToNextScreen(with: viewModel)
    }

    private func getQuestions(with: String){
        repository.getQuestions(tags: with) {[unowned self] (result) in
            DispatchQueue.main.async {
                self.handleResponse(result: result)
            }
        }
    }
    
    // MARK: - STATE
    private func handleResponse(result: Result<[Question], ApiError>){
        delegate?.hideLoadingIndicator()
        switch result {
        case .success(let questions):
            self.items = questions
            if questions.count > 0 {
                self.delegate?.didLoadQuestions()
            }
            else{
                self.delegate?.noQuestionFound(message: "No questions found".localized)
            }
        case .failure(let error):
            self.processApiError(error: error)
        }
    }

    private func processApiError(error: ApiError){
        switch error {
        case .custom(let message):
            delegate?.onApiError(message: message ?? "Technical error".localized)
        case .general(let error):
            delegate?.onApiError(message: error?.localizedDescription ?? "Technical error".localized)
        }
    }
}
