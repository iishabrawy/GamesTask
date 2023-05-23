//
//  FavoritesListVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A view controller for displaying a list of favorite games.
class FavoritesListVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesTableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: FavoritesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view controller
        self.title = "Favorites"
        viewModel = FavoritesListViewModel(host: self)
        
        // Set up the table view
        setupGamesTableView()
        
        // Set up the search bar
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Fetch favorited games from Core Data
        viewModel.getFavoritedGames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Configure the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Configure the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    /// Sets up the table view for displaying games.
    private func setupGamesTableView() {
        gamesTableView.register(GameCell.nibFile, forCellReuseIdentifier: GameCell.identifier())
        gamesTableView.dataSource = self
        gamesTableView.delegate = self
    }
    
    /// Sets up the search bar.
    private func setSearchBar() {
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return viewModel.deleteGame(at: indexPath)
    }
}

// MARK: - UISearchBarDelegate

extension FavoritesListVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the search bar and end editing
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        // Clear the search results
        viewModel.gamesList = viewModel.allGamesList
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if the search text has more than 3 characters
        if !searchText.isEmpty {
            // Perform the search
            viewModel.gamesList = viewModel.allGamesList.filter({ ($0.name ?? "").lowercased().contains(searchText.lowercased()) })
        } else if searchText.isEmpty {
            // Clear the search text and show all games
            viewModel.gamesList = viewModel.allGamesList
        }
    }
}
