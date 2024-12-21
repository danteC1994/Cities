//
//  CItiesRepositoryImplementation.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import Combine
import Foundation
import Networking

final class CitiesNetworkingRepositoryImplementation: CitiesNetworkingRepository {
    private let apiClient: APIClient

    @Published var cities: [City] = []

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchCities() async throws -> [City] {
        do {
            cities = try await apiClient.get(endpoint: .cities, queryItems: nil, headers: nil)
            return cities
        }
    }
}
