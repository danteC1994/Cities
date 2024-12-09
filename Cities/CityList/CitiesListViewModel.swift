//
//  CityListViewModel.swift
//  Cities
//
//  Created by dante canizo on 03/12/2024.
//

import Combine
import Foundation
import Networking

final class CitiesListViewModel: ObservableObject {
    let repository: CitiesRepository
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var cities: [City] = []
    @Published private(set) var error: String?
    
    init(repository: CitiesRepository) {
        self.repository = repository
        subscribeObservers()
    }

    private func subscribeObservers() {
        repository.citiesPublisher
            .receive(on: DispatchQueue.main)
            .sink(
            receiveCompletion: { [weak self] completion in
                if case let .failure(apiError) = completion {
                    self?.parseError(apiError)
                }
            }, receiveValue: { [weak self] cities in
                self?.cities = cities
            }
        ).store(in: &cancellables)
    }

    func fetchCities() async {
        repository.fetchCities()
    }

    private func parseError(_ apiError: APIError) {
        switch apiError {
        case .invalidURL,
                .decodingError,
                .encodingError,
                .unknownError:
            error = "Ups... we have technical problems. Try again later."
        case .networkError:
            error = "Ups... something went wrong, try again."
        }
    }
}
