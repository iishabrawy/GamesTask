//
//  GameDetailsVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 20/05/2023.
//

import UIKit

class GameDetailsVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var gameNameLbl: UILabel!
    @IBOutlet weak var gameDescriptionLbl: UILabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var redditView: UIView!
    @IBOutlet weak var websiteView: UIView!

    @IBOutlet weak var columnsStack: UIStackView!

    // MARK: - Properties

    var viewModel: GameDetailsViewModel!
    var gameID: Int!
    var isFavorite: Bool = false
    var favoriteButton: UIBarButtonItem = UIBarButtonItem()

    // MARK: - Initialization

    init(gameID: Int) {
        self.gameID = gameID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GameDetailsViewModel(host: self,
                                         gameDetailsEndPoint: GameDetailEndPoint(gameID: self.gameID))

        setupNavigationItems()
        configureGestureRecognizers()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.verticalSizeClass == .compact {
            // Landscape mode, double column layout
            columnsStack.axis = .horizontal
        } else {
            // Portrait mode, single column layout
            columnsStack.axis = .vertical
        }
    }

    // MARK: - Setup

    func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = false

        // Create a favorite button
        favoriteButton = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(favoriteButtonTapped))

        // Set the favorite button as the right bar button item
        navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()
    }

    func updateFavoriteButton() {
        favoriteButton.title = viewModel.isGameInFavorites() ? "Favorited" : "Favorite"
    }

    func configureGestureRecognizers() {
        redditView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReddit)))
        websiteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openWebsite)))
    }

    // MARK: - Actions

    @objc func openReddit() {
        if let redditURLString = viewModel.gameInfo?.redditUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let gameRedditURL = URL(string: redditURLString),
           UIApplication.shared.canOpenURL(gameRedditURL) {
            UIApplication.shared.open(gameRedditURL)
        }
    }

    @objc func openWebsite() {
        if let urlString = viewModel.gameInfo?.website?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let gameWebSiteURL = URL(string: urlString),
           UIApplication.shared.canOpenURL(gameWebSiteURL) {
            UIApplication.shared.open(gameWebSiteURL)
        }
    }

    @objc func favoriteButtonTapped() {
        viewModel.gameInfo?.favorite = !viewModel.isGameInFavorites()
        updateFavoriteButton()
    }

    // MARK: - Actions

    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        viewModel.loadDescription()
    }
}
