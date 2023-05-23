//
//  GamesListVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//


/*
 Documentation
 This code represents a view controller called GamesListVC that is responsible for displaying a list of games. It utilizes various UIKit components such as UISearchBar and UITableView to allow the user to search for games and view them in a table format. The view controller follows the MVC (Model-View-Controller) architectural pattern.

 Class Structure
 GamesListVC is a subclass of UIViewController and serves as the main view controller for the games list screen.
 The view controller contains the following outlets:
 searchBar: A UISearchBar instance used for searching games.
 gamesTableView: A UITableView instance used for displaying the list of games.
 noGamesLbl: A UILabel instance used to show a message when no games are searched.
 The view controller also has a property called viewModel of type GamesListViewModel, which acts as the view model for the view controller.
 Initialization
 The view controller provides an initializer init() that calls the designated initializer of UIViewController.
 The required initializer init?(coder: NSCoder) is overridden with a fatalError to indicate that it has not been implemented. This initializer is required when using storyboards or nib files.
 View Lifecycle
 viewDidLoad() is overridden to perform initial setup of the view controller.
 The viewModel is initialized with the view controller as the host.
 The title of the view controller is set to "Games".
 The table view is configured by calling setupGamesTableView().
 The search bar is configured by calling setSearchBar().
 viewWillAppear(_:) and viewDidAppear(_:) methods are overridden to set the prefersLargeTitles property of the navigation bar to true.
 viewDidDisappear(_:) is overridden to reset the prefersLargeTitles property of the navigation bar to false.
 Table View Setup
 setupGamesTableView() is a private method that configures the table view for displaying games.
 It registers the GameCell nib file with the table view using register(_:forCellReuseIdentifier:).
 It sets the data source, delegate, and prefetch data source of the table view to the view controller.
 Search Bar Setup
 setSearchBar() is a method that configures the search bar.
 It sets the delegate of the search bar to the view controller.
 It sets the autocapitalization type of the search bar to .none.
 Table View Data Source and Delegate
 The view controller conforms to the UITableViewDataSource and UITableViewDelegate protocols.
 The necessary methods are implemented to provide the data for the table view and handle row selection.
 tableView(_:numberOfRowsInSection:) returns the number of cells based on the view model's numberOfCells() method.
 tableView(_:cellForRowAt:) returns a cell for the corresponding index path using the view model's cellForRow(at:) method.
 tableView(_:didSelectRowAt:) calls the view model's didSelectCell(at:) method when a row is selected.
 Table View Data Prefetching
 The view controller conforms to the UITableViewDataSourcePrefetching protocol.
 The tableView(_:prefetchRowsAt:) method is implemented to initiate data fetching when the last few rows are about to be displayed.
 It checks if the index path of a row is within the range of the last few rows and not already fetching data.
 If the conditions are met, it calls the view model's gameWillDisplay(at:) method to initiate data fetching.
 Search Bar Delegate
 The view controller conforms to the UISearchBarDelegate protocol.
 The following delegate methods are implemented to handle search bar events:
 searchBarCancelButtonClicked(_:): Called when the cancel button of the search bar is clicked.
 It clears the search bar text and resigns the first responder status.
 It sets the search text in the view model to nil and calls the getGamesListFromFirstPage() method to retrieve the original list of games.
 searchBar(_:textDidChange:): Called when the text in the search bar changes.
 It checks if the search text has more than 3 characters.
 If it does, it sets the search text in the view model and calls the getGamesListFromFirstPage() method to perform the search.
 If the search text is empty, it sets the search text in the view model to nil and calls the getGamesListFromFirstPage() method to retrieve the original list of games.
 Overall, this view controller provides the necessary functionality for displaying a list of games, searching for games, and handling user interactions with the table view. The view controller communicates with the GamesListViewModel to retrieve and update the data displayed in the table view.
 */

import UIKit

/// A view controller for displaying a list of games.
class GamesListVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gamesTableView: UITableView!

    lazy var noGamesLbl: UILabel = {
        let label = UILabel()
        label.text = "No game has been searched."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

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

        // Initialize the view model
        viewModel = GamesListViewModel(host: self)

        title = "Games"

        setupGamesTableView()
        setSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set navigation bar appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Set navigation bar appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Reset navigation bar appearance
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
