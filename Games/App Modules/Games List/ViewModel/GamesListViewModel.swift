//
//  GamesListViewModel.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/*
 The GamesListViewModel class is responsible for providing data and handling business logic for the games list screen. It communicates with the GamesListVC view controller to update the UI and respond to user interactions.

 Properties:
 hostVC: The weak reference to the view controller that owns the view model.
 networkLayer: The network layer used for making API requests.
 gamesEndPoint: The endpoint for fetching games data.
 page: The current page number for pagination.
 allGamesList: The list of all games fetched from the API.
 gamesList: The list of games to be displayed in the table view.
 hasNextPage: A flag indicating whether there is a next page available for pagination.
 isFetching: A flag indicating whether data is currently being fetched.
 Initializer:
 The initializer takes optional parameters for the host view controller, network layer, and games endpoint. It sets the initial values, assigns the provided dependencies, and calls the getGamesListFromFirstPage() method to fetch the initial list of games.
 Methods:
 showNoDataLbl(): Adds and configures the "No Data" label as a subview of the table view.
 hideNoDataLbl(): Removes the "No Data" label from the table view.
 numberOfCells(): Returns the number of cells in the games list.
 cellForRow(at:): Returns the configured cell for the specified index path.
 didSelectCell(at:): Handles the selection of a cell at the specified index path.
 gameWillDisplay(at:): Handles the event when a game is about to be displayed. It checks if the last few rows are about to be displayed, and if so, initiates data fetching if there is a next page available and data is not already being fetched.
 openGameDetail(at:): Opens the game details view controller for the game at the specified index path.
 Overall, the GamesListViewModel class acts as an intermediary between the view controller and the data source, providing the necessary data and functionality to populate and interact with the games list screen.
 */

/// The view model for the games list screen.
class GamesListViewModel {

    /// The view controller that owns the view model.
    weak var hostVC: GamesListVC?

    /// The network layer used for making API requests.
    var networkLayer: NetworkLayer!

    /// The endpoint for fetching games data.
    var gamesEndPoint: GamesEndPoint!

    /// The current page number for pagination.
    var page = 1

    /// The list of games.
    var allGamesList: [GameDataModel] = []

    var gamesList: [GameDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                if (self.gamesList.isEmpty) {
                    self.showNoDataLbl()
                } else {
                    self.hideNoDataLbl()
                }
                self.hostVC?.gamesTableView.reloadData()
            }
        }
    }

    /// Flag indicating whether there is a next page available.
    var hasNextPage = false

    /// Flag indicating whether data is currently being fetched.
    var isFetching = false

    /// Initializes the view model with the provided dependencies.
    /// - Parameters:
    ///   - host: The view controller that owns the view model.
    ///   - networkLayer: The network layer for making API requests.
    ///   - gamesEndPoint: The endpoint for fetching games data.
    init(host: GamesListVC?, networkLayer: NetworkLayer = NetworkLayer(),
         gamesEndPoint: GamesEndPoint = GamesEndPoint(page: 1)) {
        hostVC = host
        self.networkLayer = networkLayer
        self.gamesEndPoint = gamesEndPoint
        getGamesListFromFirstPage()
    }

    /// Shows the "No Data" label in the table view.
    func showNoDataLbl() {
        if let hostVC = hostVC {
            hostVC.gamesTableView.addSubview(hostVC.noGamesLbl)
            hostVC.noGamesLbl.translatesAutoresizingMaskIntoConstraints = false
            hostVC.noGamesLbl.centerYAnchor
                .constraint(equalTo:
                                hostVC.gamesTableView.centerYAnchor).isActive = true
            hostVC.noGamesLbl.centerXAnchor
                .constraint(equalTo:
                                hostVC.gamesTableView.centerXAnchor).isActive = true
        }
    }

    /// Hides the "No Data" label from the table view.
    func hideNoDataLbl() {
        hostVC?.noGamesLbl.removeFromSuperview()
    }

    /// Returns the number of cells in the games list.
    func numberOfCells() -> Int {
        return gamesList.count
    }

    /// Returns the cell for the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The configured cell for the index path.
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = hostVC?.gamesTableView.dequeueReusableCell(
            withIdentifier: GameCell.identifier()) as? GameCell else {
            return UITableViewCell()
        }
        if gamesList.count > indexPath.row {
            cell.gameData = gamesList[indexPath.row]
        }
        return cell
    }

    /// Handles the selection of a cell at the specified index path.
    /// - Parameter indexPath: The index path of the selected cell.
    func didSelectCell(at indexPath: IndexPath) {
        hostVC?.gamesTableView.deselectRow(at: indexPath, animated: true)
        openGameDetail(at: indexPath)
    }

    /// Handles the event when a game is about to be displayed.
    /// - Parameter indexPath: The index path of the game about to be displayed.
    func gameWillDisplay(at indexPath: IndexPath) {
        if !gamesList.isEmpty && !isFetching {
            if indexPath.row >= gamesList.count - 3 && hasNextPage && !isFetching {
                DispatchQueue.main.async { [weak self] in
                    self?.getGamesList()
                }
            }
        }
    }

    /// Opens the game details view controller for the game at the specified index path.
    /// - Parameter indexPath: The index path of the game.
    func openGameDetail(at indexPath: IndexPath) {
        if gamesList.count > indexPath.row {
            guard let gameID = gamesList[indexPath.row].id else {
                return
            }
            gamesList[indexPath.row].opened = true
            let gameDetailVC = GameDetailsVC(gameID: gameID)

            // Push the view controller
            self.hostVC?.navigationController?.pushViewController(gameDetailVC, animated: true)
        }
    }
}
