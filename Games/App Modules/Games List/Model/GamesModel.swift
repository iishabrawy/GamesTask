//
//  GamesModel.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation

/// Represents the model for a list of games.
struct GamesModell: Codable, Hashable, Equatable {
    let results: [GameDataModel]?
    let count: Int?
}

/// Represents the model for game data.
struct GameDataModel: Codable, Hashable, Equatable {
    let id: Int?
    let slug: String?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let metacritic: Double?
    let genres: [GameGenres]?
    let description: String?
    var redditUrl, redditName: String?
    let website: String?
    var favorite: Bool = false
    var opened: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, rating
        case backgroundImage = "background_image"
        case metacritic, genres, description
        case redditUrl = "reddit_url"
        case redditName = "reddit_name"
        case website
    }
}

/// Represents the model for game genres.
struct GameGenres: Codable, Hashable, Equatable {
    let id: Int?
    let name, slug: String?
    let backgroundImage: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case backgroundImage = "background_image"
    }
}
