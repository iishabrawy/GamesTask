//
//  GamesListViewModelTests.swift
//  GamesTests
//
//  Created by Ismael Mahmoud AlShabrawy on 20/05/2023.
//

import XCTest
@testable import Games

class GamesListViewModelTests: XCTestCase {

    var sut: GamesListViewModel!

    override func setUp() {
        super.setUp()
        sut = GamesListViewModel(host: nil)
        sut.gamesList = [
            GameDataModel(
                id: 3498,
                slug: "grand-theft-auto-v",
                name: "Grand Theft Auto V",
                released: "2013-09-17",
                backgroundImage: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg",
                rating: 4.47,
                metacritic: 92,
                genres: [
                    GameGenres(
                        id: 4,
                        name: "Action",
                        slug: "action",
                        backgroundImage: ""
                    ),
                    GameGenres(
                        id: 3,
                        name: "Adventure",
                        slug: "adventure",
                        backgroundImage: ""
                    )
                ],
                description: "",
                redditUrl: "",
                redditName: "",
                website: "",
                favorite: false,
                opened: false
            ),
            GameDataModel(
                id: 3328,
                slug: "the-witcher-3-wild-hunt",
                name: "The Witcher 3: Wild Hunt",
                released: "2015-05-18",
                backgroundImage: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg",
                rating: 4.66,
                metacritic: 92,
                genres: [
                    GameGenres(
                        id: 4,
                        name: "Action",
                        slug: "action",
                        backgroundImage: ""                    ),
                    GameGenres(
                        id: 3,
                        name: "Adventure",
                        slug: "adventure",
                        backgroundImage: ""
                    ),
                    GameGenres(
                        id: 5,
                        name: "RPG",
                        slug: "role-playing-games-rpg",
                        backgroundImage: ""
                    )
                ],
                description: "",
                redditUrl: "",
                redditName: "",
                website: "",
                favorite: false,
                opened: false
            ),
            GameDataModel(
                id: 4200,
                slug: "portal-2",
                name: "Portal 2",
                released: "2011-04-18",
                backgroundImage: "https://media.rawg.io/media/games/328/3283617cb7d75d67257fc58339188742.jpg",
                rating: 4.62,
                metacritic: 95,
                genres: [
                    GameGenres(
                        id: 2,
                        name: "Shooter",
                        slug: "shooter",
                        backgroundImage: ""
                    ),
                    GameGenres(
                        id: 7,
                        name: "Puzzle",
                        slug: "puzzle",
                        backgroundImage: ""
                    )
                ],
                description: "",
                redditUrl: "",
                redditName: "",
                website: "",
                favorite: false,
                opened: false
            )
        ]
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testNumberOfCells_ReturnsCorrectCount() {
        // Set up the test data and verify the expected count
        XCTAssertEqual(sut.numberOfCells(), 3)
    }

    func testDidSelectCell_PerformsExpectedAction() {
        // Set up the test data and verify the expected behavior
        let indexPath = IndexPath(row: 0, section: 0)
        sut.didSelectCell(at: indexPath)
        // Add your assertion for the expected behavior after selecting a cell
        XCTAssertEqual(sut.gamesList[indexPath.row].id, 3498)
    }
}

