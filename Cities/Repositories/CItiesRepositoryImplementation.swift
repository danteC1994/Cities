//
//  CItiesRepositoryImplementation.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import Combine
import Foundation
import Networking

final class CitiesRepositoryImplementation: CitiesRepository {
    private let apiClient: APIClient
    let citiesSubject: CurrentValueSubject<[City], APIError> = .init([])
    let citiesPublisher: Publishers.Map<CurrentValueSubject<[City], APIError>, [City]>

    @Published var cities: [City] = []

    init(apiClient: APIClient) {
        self.apiClient = apiClient
        citiesPublisher = citiesSubject.map(\.self)
    }

    func fetchCities() {
        Task {
            await getCities()
        }
    }

    private func getCities() async {
        do {
            cities = try await apiClient.get(endpoint: .cities, queryItems: nil, headers: nil)
            citiesSubject.send(cities)
        } catch {
            if let error = error as? APIError {
                citiesSubject.send(completion: .failure(error))
            }
        }
    }
}
