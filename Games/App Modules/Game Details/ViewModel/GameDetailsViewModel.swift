//
//  GameDetailsViewModel.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 20/05/2023.
//

import UIKit

class GameDetailsViewModel {

    /// The view controller that owns the view model.
    weak var hostVC: GameDetailsVC?

    /// The network layer used for making API requests.
    let networkLayer: NetworkLayer

    /// The endpoint for fetching game data.
    let gameDetailsEndPoint: GameDetailEndPoint

    /// The game info.
    var gameInfo: GameDataModel? {
        didSet {
            setupUI()
            if let gameInfo = gameInfo {
                CoreDataManager.shared.updateItemByID(gameInfo.id ?? 0, withAttributes: gameInfo)
            }
        }
    }

    /// Flag indicating whether data is currently being fetched.
    var isFetching: Bool = false

    /// Initializes the view model with the provided dependencies.
    /// - Parameters:
    ///   - host: The view controller that owns the view model.
    ///   - networkLayer: The network layer for making API requests.
    ///   - gameDetailsEndPoint: The endpoint for fetching game details.
    init(host: GameDetailsVC?, networkLayer: NetworkLayer = NetworkLayer(), gameDetailsEndPoint: GameDetailEndPoint) {
        self.hostVC = host
        self.networkLayer = networkLayer
        self.gameDetailsEndPoint = gameDetailsEndPoint
        getGameDetails()
    }

    /// Sets up the UI with game information.
    private func setupUI() {
        if let gameInfo = gameInfo {
            DispatchQueue.main.async { [weak self] in
                // Update game name label
                self?.hostVC?.gameNameLbl.text = gameInfo.name ?? ""

                // Update game description label
                self?.hostVC?.gameDescriptionLbl.text = (gameInfo.description ?? "").htmlDataToString ?? ""

                // Load game image asynchronously
                (gameInfo.backgroundImage ?? "").loadImage { [weak self] image in
                    DispatchQueue.main.async {
                        self?.hostVC?.gameImage.image = image ?? UIImage(named: "ic_games")
                        self?.hostVC?.indicator.stopAnimating()
                    }
                }
            }
        }
    }

    /// Loads the full description of the game.
    func loadDescription() {
        if let gameInfo = gameInfo, let hostVC = hostVC {
            hostVC.gameDescriptionLbl.alpha = 0.2
            UIView.animate(withDuration: 0.5) {
                let fullSize = hostVC.gameDescriptionLbl.systemLayoutSizeFitting(
                    CGSize(width: hostVC.gameDescriptionLbl.frame.size.width,
                           height: CGFloat.greatestFiniteMagnitude),
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                )

                // Toggle number of lines and update "Read More" button title
                hostVC.gameDescriptionLbl.numberOfLines = hostVC.gameDescriptionLbl.numberOfLines == 4 ? 0 : 4
                hostVC.readMoreBtn.setTitle(hostVC.gameDescriptionLbl.numberOfLines == 4 ? "Read More" : "Read Less", for: .normal)

                // Adjust label height based on the number of lines
                hostVC.gameDescriptionLbl.frame.size.height = hostVC.gameDescriptionLbl.numberOfLines == 4 ? fullSize.height : hostVC.gameDescriptionLbl.font.lineHeight * 4
                hostVC.gameDescriptionLbl.text = (gameInfo.description ?? "").htmlDataToString ?? ""
                hostVC.gameDescriptionLbl.alpha = 1
                hostVC.view.layoutIfNeeded()
            }
        }
    }

    /// Checks if the game is in the favorites list.
    /// - Returns: `true` if the game is in favorites, `false` otherwise.
    func isGameInFavorites() -> Bool {
        guard let gameID = hostVC?.gameID else { return false }
        let gameData = CoreDataManager.shared.getItemByID(gameID)
        return gameData?.favorite ?? false
    }
}
