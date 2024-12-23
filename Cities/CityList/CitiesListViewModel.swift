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
    @Published var searchText: String = ""
    @Published private(set) var citiesToDisplay: [City] = []
    @Published private(set) var error: UIError?
    @Published private(set) var informativeError: UIInformativeError?
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    @Published private(set) var loading: Bool = false
    private(set) var sortedCities: [City] = []
    private(set) var filteredCities: [City] = []
    private var cancellables = Set<AnyCancellable>()
    private let filterDelegate: AnyArrayFilter<City>
    private let netwrorkingErrorHandler: NetworkingErrorHandler
    private let databaseErrorHandler: DatabaseErrorHandler
    private let networkingRepository: CitiesNetworkingRepository
    private let databaseRepository: CitiesDatabaseRepository
    
    init(
        networkingRepository: CitiesNetworkingRepository,
        filterDelegate: AnyArrayFilter<City>,
        netwrorkingErrorHandler: NetworkingErrorHandler,
        databaseErrorHandler: DatabaseErrorHandler,
        databaseRepository: CitiesDatabaseRepository
    ) {
        self.networkingRepository = networkingRepository
        self.filterDelegate = filterDelegate
        self.netwrorkingErrorHandler = netwrorkingErrorHandler
        self.databaseErrorHandler = databaseErrorHandler
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
            let cities = try await networkingRepository.fetchCities()
            sortedCities = cities.sorted()
            filteredCities = sortedCities
            citiesToDisplay = sortedCities
            await updateSavedCities(on: citiesToDisplay)
        } catch {
            self.error = netwrorkingErrorHandler.handle(error: error as? APIError ?? .unknownError)
        }
    }

    @MainActor
    func toggleFavorite(for city: City) async {
        if let index = citiesToDisplay.firstIndex(where: { $0.id == city.id }) {
            citiesToDisplay[index].isFavorite.toggle()
            do {
                try await databaseRepository.updateCityFavorite(citiesToDisplay[index])
            } catch {
                informativeError = databaseErrorHandler.handle(error: error as? DatabaseError ?? .unknownError)
                switch informativeError {
                case .informativeError(let message):
                    toastMessage = message
                    showToast = true
                case nil:
                    break
                }

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
        } catch {
            
        }
    }

    private func filter(cities: [City], with prefix: String) -> [City] {
        return filterDelegate.filter(cities: cities, with: prefix)
    }
}
