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
                self.hostVC?.title = self.allGamesList.count > 0 ? "Favorites (\(self.allGamesList.count))" : "Favorites"
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
    
    /// Fetches the favorited games from the Core Data.
    func getFavoritedGames() {
        allGamesList = CoreDataManager.shared.fetchFavoritedGames()
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
            withIdentifier: GameCell.identifier()) as? GameCell {
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
    
    /// Delete Action
    func trailingSwipeAction(indexPath byIndex: IndexPath) -> UISwipeActionsConfiguration {
        var game = self.gamesList[byIndex.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            // Create the alert controller
            let alertController = UIAlertController(title: "Delete Game", message: "Are you sure you want to delete this game?", preferredStyle: .alert)
            
            // Add the delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
                // Perform the deletion of the game here
                // You can access the game using the indexPath parameter
                // For example: let game = games[indexPath.row]
                // Delete the game from your data source and update the table view accordingly
                self?.allGamesList.remove(at: byIndex.row)
                self?.gamesList = self?.allGamesList ?? []
                game.favorite = false
                CoreDataManager.shared.updateItemByID(game.id ?? 0, withAttributes: game)
            }
            alertController.addAction(deleteAction)
            
            // Add the cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            self?.hostVC?.present(alertController, animated: true, completion: nil)
            
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
            self.hostVC?.navigationController?
                .pushViewController(gameDetailVC, animated: true)
        }
    }
}
