//
//  CityRepositoryMock.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

import Networking

final class CitiesRepositoryMock: CitiesRepository {
    let apiClient: APIClientMock

    init(error: APIError? = nil) {
        self.apiClient = APIClientMock()
        apiClient.error = error
    }
    func fetchCities() async throws -> [City] {
        do {
            apiClient.response = CitiesTestData.getCities()
            return try await apiClient.get(endpoint: .cities, queryItems: nil, headers: nil)
        } catch {
            throw error
        }
    }
}
