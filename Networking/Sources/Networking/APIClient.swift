//
//  APIClientProtocol.swift
//  Networking
//
//  Created by dante canizo on 02/12/2024.
//

public protocol APIClient {
    func get<T: Decodable>(endpoint: Endpoint, queryItems: [String: String]?, headers: [String: String]?) async throws -> T
}
