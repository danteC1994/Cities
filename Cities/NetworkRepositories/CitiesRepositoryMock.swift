//
//  CityRepositoryMock.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import Networking

final class CitiesNetworkingRepositoryMock: CitiesNetworkingRepository {
    let apiClient: APIClientMock
    var citiesResponse: [City] = CitiesTestData.getCities()
    var error: APIError? = nil
    var didFetchCities = false

    init() {
        self.apiClient = APIClientMock()
    }

    func fetchCities() async throws -> [City] {
        do {
            apiClient.response = citiesResponse
            apiClient.error = error
            didFetchCities = true
            return try await apiClient.get(endpoint: .cities, queryItems: nil, headers: nil)
        } catch {
            throw error
        }
    }
}
