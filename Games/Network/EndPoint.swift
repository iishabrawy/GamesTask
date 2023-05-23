//
//  Endpoint.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation

/// Represents a network endpoint.
protocol Endpoint {
    /// The base URL for the endpoint.
    var baseURL: String { get }

    /// The specific endpoint within the base URL.
    var endPoint: EndPoints { get }

    /// The HTTP method to be used for the request.
    var httpMethod: HTTPMethod { get }

    /// The headers to be included in the request.
    var headers: [String: String] { get }

    /// The parameters to be included in the request body.
    var parameters: [String: Any]? { get }

    /// The query parameters to be included in the request URL.
    var queryParameters: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        get { return GamesEnvironment.apiRootURL.absoluteString }
    }

    var httpMethod: HTTPMethod {
        get { return .get }
    }

    var headers: [String: String] {
        get { return ["Content-Type": "application/json"] }
    }

    var parameters: [String: Any]? {
        get { return nil }
    }
}
