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
    var citiesCurrentIndex = 0
    let repository: CitiesRepository
    private var cancellables = Set<AnyCancellable>()
    private(set) var sortedCities: [City] = []
    private(set) var filteredCities: [City] = []
    private(set) var unfilteredCities: [City] = []
    @Published private(set) var citiesToDisplay: [City] = []
    @Published private(set) var error: String?
    @Published var searchText: String = ""
    
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
                guard let self else { return }
                self.sortedCities = cities.sorted()
                self.updateUnfilteredCities()
                citiesToDisplay = unfilteredCities
            }
        ).store(in: &cancellables)

        $searchText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    citiesToDisplay = unfilteredCities
                    return
                }
                let partialResult = searchText > self.searchText ? filteredCities : sortedCities
                self.filter(cities: partialResult, with: searchText)
                citiesToDisplay = filteredCities
            }).store(in: &cancellables)
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

    func filter(cities: [City], with prefix: String) {
        filteredCities = filterCitiesThatStartWith(prefix: prefix, in: cities)
    }

    func binarySearch(for prefix: String, in cities: [City]) -> Int? {
        var low = 0
        var high = cities.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            let midCity = cities[mid].name.lowercased()

            if midCity.hasPrefix(prefix.lowercased()) {
                return mid
            } else if midCity < prefix.lowercased() {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }

        return nil
    }

    func filterCitiesThatStartWith(prefix: String, in cities: [City]) -> [City] {
        guard let startIndex = binarySearch(for: prefix, in: cities) else {
            return []
        }
        
        var results: [City] = []
        
        var index = startIndex
        while index < cities.count && cities[index].name.lowercased().hasPrefix(prefix.lowercased()) {
            results.append(cities[index])
            index += 1
        }
        
        return results
    }
}

extension CitiesListViewModel {
    func updateUnfilteredCities() {
        let lastIndex = sortedCities.count - 1
        guard lastIndex != citiesCurrentIndex else { return }

        let nextIndex = min(lastIndex, (citiesCurrentIndex + 100))
        guard nextIndex > 0 else { return }
        unfilteredCities.append(contentsOf: sortedCities[citiesCurrentIndex...100])
        citiesCurrentIndex = nextIndex
    }
}
