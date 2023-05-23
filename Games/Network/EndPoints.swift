//
//  EndPoints.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation

/// Represents the available endpoints for the network API.
enum EndPoints {
    case gamesList
    case gameInfo(gameID: Int)

    /// Returns the path for the endpoint.
    func path() -> String {
        switch self {
        case .gamesList:
            return "games"
        case .gameInfo(let gameID):
            return "games/\(gameID)"
        }
    }
}
