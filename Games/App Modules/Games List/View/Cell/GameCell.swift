//
//  GameCell.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import UIKit

/// A custom table view cell for displaying game information.
class GameCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var gameNameLbl: UILabel!
    @IBOutlet weak var metacriticLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!

    /// The game data to be displayed in the cell.
    var gameData: GameDataModel? {
        didSet {
            if let gameData = gameData {
                // Set the game name label
                gameNameLbl.text = gameData.name ?? ""

                // Set the metacritic label
                metacriticLbl.text = "\(gameData.metacritic ?? 0)"

                // Set the genres label
                let genreNames = gameData.genres?.map { $0.name ?? "" }
                    .joined(separator: gameData.genres?.count ?? 0 > 1 ? ", " : "")
                genresLbl.text = genreNames ?? ""

                // Load the game image asynchronously
                (gameData.backgroundImage ?? "").loadImage { [weak self] image in
                    DispatchQueue.main.async {
                        self?.gameImg.image = image ?? UIImage(named: "ic_games")
                        self?.indicator.stopAnimating()
                    }
                }

                // Set the cell background color based on the game's opened state
                self.backgroundColor = gameData.opened ?
                DesignSystem.AppColors.openedGameBGColor.color :
                DesignSystem.AppColors.whiteColor.color
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Resets the cell to its initial state.
    func resetCell() {
        gameImg.image = nil
        indicator.startAnimating()
        gameNameLbl.text = nil
        metacriticLbl.text = nil
        genresLbl.text = nil
    }
}
