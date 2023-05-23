//
//  GamesListVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A view controller for displaying a list of games.
class GamesListVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesTableView: UITableView!

    // MARK: - Properties

    var viewModel: GamesListViewModel!

    /// Initializes a new instance of the view controller.
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GamesListViewModel(host: self)

        title = "Games"

        setupGamesTableView()
        setSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    /// Sets up the table view for displaying games.
    private func setupGamesTableView() {
        gamesTableView.register(GameCell.nibFile, forCellReuseIdentifier: GameCell.identifier())
        gamesTableView.dataSource = self
        gamesTableView.delegate = self
        gamesTableView.prefetchDataSource = self
    }

    func setSearchBar() {
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
//        searchBar.showsCancelButton = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GamesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension GamesListVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Check if the last few rows are about to be displayed and initiate data fetching if needed
        for index in indexPaths where (index.row >= viewModel.gamesList.count - 3) && !viewModel.isFetching {
            viewModel.gameWillDisplay(at: index)
            break // Fetching initiated, no need to continue the loop
        }
    }
}

extension GamesListVC: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the search bar and end editing
        searchBar.text = nil
        searchBar.resignFirstResponder()

        // Clear the search results
        viewModel.gamesEndPoint.searchText = nil
        viewModel.getGamesListFromFirstPage()
        // Reload the table view to show the original data
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if the search text has more than 3 characters
        if searchText.count > 3 {
            // Perform the search
            viewModel.gamesEndPoint.searchText = searchText
            viewModel.getGamesListFromFirstPage()
        } else if searchText.isEmpty {
            viewModel.gamesEndPoint.searchText = nil
            viewModel.getGamesListFromFirstPage()
        }
    }
}
