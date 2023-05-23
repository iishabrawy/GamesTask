//
//  NetworkError.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation

/// Represents the possible network errors.
enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case invalidData
}
