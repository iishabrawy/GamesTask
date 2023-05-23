//
//  GamesEnvironment.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 23/05/2023.
//

import Foundation
import GamesKeys

enum GamesEnvironment {

    static let apiRootURL: URL = {
        var urlString = ""
#if GamesDev
        urlString = GamesKeys.Keys.Global().apiRootURLDev
#elseif GamesProd
        urlString = GamesKeys.Keys.Global().apiRootURLProd
#endif
        guard let apiURL = URL(string: urlString) else {
            fatalError("API_ROOT_URL is invalid")
        }
        return apiURL
    }()
}
