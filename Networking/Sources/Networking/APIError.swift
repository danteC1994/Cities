//
//  APIError.swift
//  Networking
//
//  Created by dante canizo on 02/12/2024.
//

enum APIError: Error {
    case invalidURL
    case networkError(String)
    case decodingError(Error)
    case encodingError(Error)
    case unknownError
}
