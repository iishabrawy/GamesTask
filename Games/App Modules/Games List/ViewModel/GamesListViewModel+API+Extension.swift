//
//  GamesListViewModel+API+Extension.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

extension GamesListViewModel {
    // MARK: - API

    /// Fetches the list of games.
    func getGamesList() {
        isFetching = true
        networkLayer.request(endpoint: gamesEndPoint) { [weak self] (result: Result<GamesModell, Error>) in
            switch result {
            case .success(let successResponse):
                self?.hasNextPage = ((successResponse.count ?? 0) / 20) > (self?.page ?? 0)
                self?.page = self?.hasNextPage == true ? ((self?.page ?? 1) + 1) : (self?.page ?? 1)
                self?.gamesList.append(contentsOf: successResponse.results ?? [])
                self?.gamesList = self?.gamesList.removeDuplicates() ?? []
                self?.allGamesList = self?.gamesList ?? []
                CoreDataManager.shared.saveGamesModels(successResponse.results ?? [])
                self?.gamesEndPoint.page += 1
            case .failure:
                self?.getFromLocalCoreData()
            }

            self?.isFetching = false
        }
    }

    func getGamesListFromFirstPage() {
        gamesList.removeAll()
        allGamesList.removeAll()
        gamesEndPoint.page = 1
        getGamesList()
    }

    func getFromLocalCoreData() {
        var localGames = CoreDataManager.shared.fetchGamesModels()
        localGames.removeAll(where: { $0.id == nil || $0.id ?? 0 <= 0 })
        gamesList = localGames.removeDuplicates()
        self.allGamesList = self.gamesList 
    }
}
