//
//  APIRouter.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation
import GamesKeys

struct GamesEndPoint: Endpoint {
    var page: Int
    var searchText: String?

    var endPoint: EndPoints {
        .gamesList
    }

    var queryParameters: [String: String]? {
        var params: [String: String] = [
            "page_size": "20",
            "page": String(page),
            "key": GamesKeys.Keys.Global().apiKey
        ]

        if let searchText = searchText {
            params["search"] = searchText
        }

        return params
    }
}

struct GameDetailEndPoint: Endpoint {
    var gameID: Int
    
    var endPoint: EndPoints {
        .gameInfo(gameID: gameID)
    }

    var queryParameters: [String: String]? {
        ["key": GamesKeys.Keys.Global().apiKey]
    }
}
