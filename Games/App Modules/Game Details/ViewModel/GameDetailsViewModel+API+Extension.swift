//
//  GameDetailsViewModel+API+Extension.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 20/05/2023.
//

import UIKit

extension GameDetailsViewModel {
    
    // MARK: - API
    
    /// Fetches the game details.
    func getGameDetails() {
        isFetching = true
        networkLayer.request(endpoint: gameDetailsEndPoint) { [weak self] (result: Result<GameDataModel, Error>) in
            switch result {
            case .success(let successResponse):
                // Update the gameInfo with the fetched data
                var successResponse = successResponse
                successResponse.favorite = self?.isGameInFavorites() ?? false
                self?.gameInfo = successResponse
            case .failure:
                // If the request fails, fallback to the locally stored game data
                self?.gameInfo = CoreDataManager.shared.getItemByID(self?.gameDetailsEndPoint.gameID ?? 0)
            }
            self?.isFetching = false
        }
    }
}
