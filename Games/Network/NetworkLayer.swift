//
//  NetworkLayer.swift
//  Games
//
//  Created by Ismael Mahmoud AlShabrawy on 19/05/2023.
//

import Foundation

/// Handles network requests.
class NetworkLayer {
    /// Sends a network request.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to.
    ///   - completion: The completion block to be called when the request completes.
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard var components = URLComponents(string: endpoint.baseURL + endpoint.endPoint.path()) else {
            return completion(.failure(NetworkError.invalidURL))
        }

        if let queryParameters = endpoint.queryParameters {
            components.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }

        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        if let parameters = endpoint.parameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters) {
                request.httpBody = jsonData
            }
        }

        debugPrint("request is \(request)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
