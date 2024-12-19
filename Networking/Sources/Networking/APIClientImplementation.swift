//
//  APIClient.swift
//  Networking
//
//  Created by dante canizo on 02/12/2024.
//

import Foundation

public class APIClientImplementation: APIClient {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    private func buildURL(endpoint: Endpoint, queryItems: [String: String]?) -> URL? {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.urlString), resolvingAgainstBaseURL: false) else {
            return nil
        }
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return urlComponents.url
    }

    public func get<T: Decodable>(endpoint: Endpoint, queryItems: [String: String]? = nil, headers: [String: String]?) async throws -> T {
        guard let url = buildURL(endpoint: endpoint, queryItems: queryItems) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

