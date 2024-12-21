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
//    var citiesCurrentIndex = 0

    let repository: CitiesNetworkingRepository
    private var cancellables = Set<AnyCancellable>()
    private(set) var sortedCities: [City] = []
    private(set) var filteredCities: [City] = []
    @Published private(set) var citiesToDisplay: [City] = []
    @Published private(set) var error: UIError?
    @Published private(set) var loading: Bool = false
    @Published var searchText: String = ""
    private let filterDelegate: AnyArrayFilter<City>
    private let errorHandler: ErrorHandler
    let databaseRepository: CitiesDatabaseRepository
    
    init(repository: CitiesNetworkingRepository, filterDelegate: AnyArrayFilter<City>, errorHandler: ErrorHandler, databaseRepository: CitiesDatabaseRepository) {
        self.repository = repository
        self.filterDelegate = filterDelegate
        self.errorHandler = errorHandler
        self.databaseRepository = databaseRepository
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
            await updateSavedCities(on: citiesToDisplay)
        } catch {
            self.error = errorHandler.handle(error: error as? APIError ?? .unknownError)
        }
    }

    @MainActor
    func toggleFavorite(for city: City) async {
        if let index = citiesToDisplay.firstIndex(where: { $0.id == city.id }) {
            citiesToDisplay[index].isFavorite.toggle()
            do {
                try await databaseRepository.updateCityFavorite(citiesToDisplay[index])
            } catch {
                print(error)
            }
        }
    }

    @MainActor
    private func updateSavedCities(on cities: [City]) async {
        do {
            let savedCities = try await databaseRepository.fetchCities()
            savedCities.forEach { city in
                cities.first(where: { $0.id == city.id })?.isFavorite = city.isFavorite
            }
            print(cities)
        } catch {
            
        }
    }

    func filter(cities: [City], with prefix: String) -> [City] {
        return filterDelegate.filter(cities: cities, with: prefix)
    }
}
