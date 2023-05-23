//
//  FavoritesListViewModel.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 22/05/2023.
//

import UIKit

/// The view model for the favorites list screen.
class FavoritesListViewModel {

    /// The view controller that owns the view model.
    weak var hostVC: FavoritesListVC?

    /// The list of games.
    var gamesList: [GameDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.hostVC?.gamesTableView.reloadData()
                self.hostVC?.title = self.allGamesList.count > 0 ?
                "Favorites (\(self.allGamesList.count))" : "Favorites"
            }
        }
    }

    var allGamesList: [GameDataModel] = []

    /// Initializes the view model with the provided dependencies.
    /// - Parameters:
    ///   - host: The view controller that owns the view model.
    init(host: FavoritesListVC?) {
        hostVC = host
    }

    /// Fetches the favorited games from Core Data.
    func getFavoritedGames() {
        allGamesList = CoreDataManager.shared.fetchFavoritedGamesModels()
        gamesList = allGamesList
    }

    /// Returns the number of cells in the games list.
    func numberOfCells() -> Int {
        return gamesList.count
    }

    /// Returns the cell for the specified index path.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: The configured cell for the index path.
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        if let cell = hostVC?.gamesTableView.dequeueReusableCell(
            withIdentifier: GameCell.identifier(), for: indexPath) as? GameCell {
            cell.gameData = gamesList[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }

    /// Handles the selection of a cell at the specified index path.
    /// - Parameter indexPath: The index path of the selected cell.
    func didSelectCell(at indexPath: IndexPath) {
        hostVC?.gamesTableView.deselectRow(at: indexPath, animated: true)
        openGameDetail(at: indexPath)
    }

    /// Deletes a game from the favorites list.
    /// - Parameter indexPath: The index path of the game to be deleted.
    func deleteGame(at indexPath: IndexPath) -> UISwipeActionsConfiguration {
        var game = gamesList[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            // Create the alert controller
            let deleteConfirmation = UIAlertController(
                title: "Delete Game",
                message: "Are you sure you want to delete this game?",
                preferredStyle: .alert
            )

            // Add the delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                // Remove the game from the favorites list
                self?.allGamesList.remove(at: indexPath.row)
                self?.gamesList = self?.allGamesList ?? []
                game.favorite = false
                CoreDataManager.shared.updateItemByID(game.id ?? 0, withAttributes: game)
            }
            deleteConfirmation.addAction(deleteAction)

            // Add the cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteConfirmation.addAction(cancelAction)

            // Present the alert controller
            self?.hostVC?.present(deleteConfirmation, animated: true, completion: nil)

            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    /// Opens the game details screen for the selected game.
    /// - Parameter indexPath: The index path of the selected game.
    func openGameDetail(at indexPath: IndexPath) {
        if let gameID = gamesList[indexPath.row].id {
            let gameDetailVC = GameDetailsVC(gameID: gameID)

            // Push the view controller
            hostVC?.navigationController?.pushViewController(gameDetailVC, animated: true)
        }
    }
}
