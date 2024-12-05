//
//  APIClientProtocol.swift
//  Networking
//
//  Created by dante canizo on 02/12/2024.
//

protocol APIClientProtocol {
    func get<T: Decodable>(endpoint: Endpoint, queryItems: [String: String]?, headers: [String: String]?) async throws -> T
}
