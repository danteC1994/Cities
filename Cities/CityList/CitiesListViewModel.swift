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
//    private(set) var unfilteredCities: [City] = []
    @Published private(set) var citiesToDisplay: [City] = []
    @Published private(set) var error: UIError?
    @Published private(set) var loading: Bool = false
    @Published var searchText: String = ""
    private let filterDelegate: AnyArrayFilter<City>
    private let errorHandler: ErrorHandler
    
    init(repository: CitiesRepository, filterDelegate: AnyArrayFilter<City>, errorHandler: ErrorHandler) {
        self.repository = repository
        self.filterDelegate = filterDelegate
        self.errorHandler = errorHandler
        subscribeObservers()
    }

    private func subscribeObservers() {
        $searchText
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    citiesToDisplay = sortedCities
                    return
                }
                let partialResult = searchText > self.searchText ? filteredCities : sortedCities
                self.filteredCities = self.filter(cities: partialResult, with: searchText)
                citiesToDisplay = self.filteredCities
            }).store(in: &cancellables)
    }

    @MainActor
    func fetchCities() async {
        loading = true
        defer { loading = false }
        do {
            let cities = try await repository.fetchCities()
            sortedCities = cities.sorted()
            filteredCities = sortedCities
            citiesToDisplay = sortedCities
        } catch {
            self.error = errorHandler.handle(error: error as? APIError ?? .unknownError)
        }
    }

//    private func parseError(_ apiError: APIError) {
//        switch apiError {
//        case .invalidURL,
//                .decodingError,
//                .encodingError,
//                .unknownError:
//            error = "Ups... we have technical problems. Try again later."
//        case .networkError:
//            error = "Ups... something went wrong, try again."
//        }
//    }

    func filter(cities: [City], with prefix: String) -> [City] {
        return filterDelegate.filter(cities: cities, with: prefix)
    }
}

// TODO: check if necessary.
extension CitiesListViewModel {

    func reachLastElement() {
        updateUnfilteredCities()
//        citiesToDisplay = unfilteredCities
    }

    func updateUnfilteredCities() {
        let lastIndex = sortedCities.count - 1
        guard lastIndex != citiesCurrentIndex else { return }

        let nextIndex = min(lastIndex, (citiesCurrentIndex + 30))
        guard nextIndex > 0 else { return }
//        unfilteredCities.append(contentsOf: sortedCities[citiesCurrentIndex...nextIndex])
        citiesCurrentIndex = nextIndex
    }
}
