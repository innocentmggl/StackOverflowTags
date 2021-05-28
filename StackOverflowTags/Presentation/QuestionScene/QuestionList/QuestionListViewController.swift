//
//  QuestionListViewController.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/25.
//

import UIKit

final class QuestionListViewController: QuestionBaseViewController {

    private lazy var  viewModel: QuestionListViewModel = QuestionListViewModel(delegate: self)
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var backgroundView = TableViewBackgroundView(frame: self.view.bounds)

    @Inject
    var loadingIndicator: LoadingIndicator

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }

    private func configureViews() {
        backgroundView.delegate = self
        self.configureTableView()
        self.configureSearchController()
    }

    private func configureTableView() {
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.cellReuseIdentifier)
        tableView.rowHeight = 85.0
        backgroundView.setInfoLabelText(text: "Stack Overflow Search".localized)
        tableView.backgroundView = backgroundView
    }

    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        searchController.searchBar.placeholder = "Search".localized
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = .white
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.backgroundColor = .white
        } else {
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.backgroundColor = .white
            }
        }
    }
}

// MARK: - VIEW MODEL DELEGATE
extension QuestionListViewController : QuestionListViewModelDelegate{
    func showLoadingIndicator() {
        loadingIndicator.showLoadingIndicator(onView: self.view)
    }

    func hideLoadingIndicator() {
        loadingIndicator.hideLoadingIndicator()
    }

    func didLoadQuestions() {
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
    }

    func noQuestionFound(message: String){
        self.tableView.reloadData()
        self.tableView.backgroundView = backgroundView
        backgroundView.setInfoLabelText(text: message, withRetry: true)
    }

    func onApiError(message: String) {
        self.tableView.backgroundView = backgroundView
        backgroundView.setInfoLabelText(text: message, withRetry: true)
    }

    func navigateToNextScreen(with viewModel: QuestionDetailsViewModel){
        self.navigationController?.pushViewController(QuestionDetailsViewController(viewModel: viewModel), animated: true)
    }
}

// MARK: - UITABLEVIEW DATASOURCE
extension QuestionListViewController: UITableViewDataSource  {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.cellReuseIdentifier,
                                                       for: indexPath) as? QuestionTableViewCell else { fatalError("Unexpected Table View Cell") }

        let item = self.viewModel.items[indexPath.row]
        let viewModel = QuestionListItemViewModel(item: item)
        cell.configure(with: viewModel)
        cell.contentView.layoutIfNeeded()
        return cell
    }
}

// MARK: - UITABLEVIEW DELEGATES
extension QuestionListViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectItemAt(row: indexPath.row)
    }

}

// MARK: - SEARCH CONTROLLER  DELEGATE
extension QuestionListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.searchText = searchController.searchBar.text
    }
}
// MARK: - UI SEARCH BAR  DELEGATE
extension QuestionListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true)
        viewModel.performQuery()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true)
    }
}
// MARK: - UI SEARCH BAR  DELEGATE
extension QuestionListViewController: TableViewBackgroundViewDelegate {
    func didTapRetry() {
        searchController.searchBar.becomeFirstResponder()
    }
}
