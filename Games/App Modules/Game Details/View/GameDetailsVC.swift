//
//  GameDetailsVC.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 20/05/2023.
//

import UIKit

/**
 The GameDetailsVC class represents the view controller responsible for displaying game details. It manages the UI elements, user interactions, and communicates with the GameDetailsViewModel to retrieve and update data.

 Outlets:
 gameImage: UIImageView for displaying the game's image.
 indicator: UIActivityIndicatorView for showing loading activity.
 gameNameLbl: UILabel for displaying the game's name.
 gameDescriptionLbl: UILabel for displaying the game's description.
 readMoreBtn: UIButton for expanding the game's description.
 redditView: UIView for opening the game's Reddit page.
 websiteView: UIView for opening the game's website.
 columnsStack: UIStackView for managing the layout of the view.
 Properties:
 viewModel: Instance of GameDetailsViewModel to handle the business logic and data for the view.
 gameID: The ID of the game for which the details are being displayed.
 isFavorite: A boolean indicating whether the game is favorited or not.
 favoriteButton: UIBarButtonItem representing the favorite button in the navigation bar.
 Initialization:
 init(gameID:): Initializes the view controller with a game ID.
 required init?(coder:): Required initializer not implemented.
 View Lifecycle:
 viewDidLoad(): Called after the view controller's view is loaded into memory. Sets up the view model, navigation items, gesture recognizers, and layout.
 traitCollectionDidChange(_:): Called when the view controller's trait collection changes. Adjusts the layout based on the new trait collection.
 Setup:
 setupNavigationItems(): Configures the navigation items, including the favorite button.
 updateFavoriteButton(): Updates the title of the favorite button based on whether the game is favorited or not.
 configureGestureRecognizers(): Configures the tap gesture recognizers for the Reddit and website views.
 changeLayoutFromOneColumnToTwoColumns(): Changes the layout of the view based on the device's orientation.
 Actions:
 openReddit(): Handles the tap gesture on the Reddit view by opening the game's Reddit page if it exists and the URL is valid.
 openWebsite(): Handles the tap gesture on the website view by opening the game's website if it exists and the URL is valid.
 favoriteButtonTapped(): Handles the tap on the favorite button by toggling the game's favorite status and updating the favorite button title.
 readMoreButtonTapped(_:): Handles the tap on the read more button by requesting to load the full game description.
 The GameDetailsVC class manages the presentation and user interaction of the game details screen, allowing users to view the game's information, toggle its favorite status, and navigate to related external links.
 */

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
        changeLayoutFromOneColumnToTwoColumns()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        changeLayoutFromOneColumnToTwoColumns()
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

    func changeLayoutFromOneColumnToTwoColumns() {
        UIView.animate(withDuration: 0.01) { [weak self] in
            if self?.traitCollection.verticalSizeClass == .compact {
                // Landscape mode, double column layout
                self?.columnsStack.axis = .horizontal
            } else {
                // Portrait mode, single column layout
                self?.columnsStack.axis = .vertical
            }
            self?.view.layoutIfNeeded()
        }
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
