//
//  GamesListViewModel.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

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
