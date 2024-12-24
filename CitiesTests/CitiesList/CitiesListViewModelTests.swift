//
//  CitiesListViewModelTests.swift
//  Cities
//
//  Created by dante canizo on 24/12/2024.
//

import Combine
import XCTest
import SwiftUI
@testable import Cities

class CitiesListViewModelTests: XCTestCase {
    var viewModel: CitiesListViewModel!
    var networkingRepositoryMock: CitiesNetworkingRepositoryMock!
    var databaseRepositoryMock: CitiesDatabaseRepositoryMock!
    var errorHandler: GenericErrorHandler!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        networkingRepositoryMock = CitiesNetworkingRepositoryMock()
        databaseRepositoryMock = CitiesDatabaseRepositoryMock()
        errorHandler = GenericErrorHandler()
        
        viewModel = CitiesListViewModel(
            networkingRepository: networkingRepositoryMock,
            filterDelegate: AnyArrayFilter(BinarySearchFilter()),
            netwrorkingErrorHandler: errorHandler,
            databaseErrorHandler: errorHandler,
            databaseRepository: databaseRepositoryMock
        )
    }

    override func tearDown() {
        viewModel = nil
        networkingRepositoryMock = nil
        databaseRepositoryMock = nil
        errorHandler = nil
        super.tearDown()
    }

    func test_fetchCities_success() async {
        let testCities = CitiesTestData.getCities()
        networkingRepositoryMock.citiesResponse = testCities
        
        await viewModel.fetchCitiesIfNeeded()
        
        XCTAssertFalse(viewModel.citiesToDisplay.isEmpty)
        XCTAssertEqual(viewModel.citiesToDisplay.count, 3)
    }

    func test_fetchCities_avoidFetchingWhenCitiesListIsNotEmpty() async {
        let testCities = CitiesTestData.getCities()
        networkingRepositoryMock.citiesResponse = testCities
        
        await viewModel.fetchCitiesIfNeeded()
        
        XCTAssertFalse(viewModel.citiesToDisplay.isEmpty)
        XCTAssertEqual(viewModel.citiesToDisplay.count, 3)
        XCTAssertTrue(networkingRepositoryMock.didFetchCities)

        networkingRepositoryMock.didFetchCities = false

        // Try to request cities again
        await viewModel.fetchCitiesIfNeeded()

        XCTAssertFalse(networkingRepositoryMock.didFetchCities)
    }

    func test_fetchCities_failure() async {
        networkingRepositoryMock = CitiesNetworkingRepositoryMock()
        networkingRepositoryMock.error = .networkError("Network error")
        viewModel = CitiesListViewModel(
            networkingRepository: networkingRepositoryMock,
            filterDelegate: AnyArrayFilter<City>(BinarySearchFilter()),
            netwrorkingErrorHandler: errorHandler,
            databaseErrorHandler: errorHandler,
            databaseRepository: databaseRepositoryMock
        )

        await viewModel.fetchCitiesIfNeeded()
        
        XCTAssertNotNil(viewModel.error)
    }

    func test_toggleFavorite_updatesFavoriteStatus() async throws {
        let cityToToggle = City(id: 707860, name: "Hurzuf", country: "UA", coordinates: City.Coordinates(lon: 34.283333, lat: 44.549999), isFavorite: false)
        networkingRepositoryMock.citiesResponse = CitiesTestData.getCities()
        
        await viewModel.fetchCitiesIfNeeded()
        await viewModel.toggleFavorite(for: cityToToggle)

        let city = try XCTUnwrap(viewModel.citiesToDisplay.first(where: { $0.id == cityToToggle.id }))
        XCTAssertTrue(city.isFavorite)
        
        await viewModel.toggleFavorite(for: cityToToggle)

        XCTAssertFalse(viewModel.citiesToDisplay[0].isFavorite)
    }

    func test_filterCities() async {
        let testCities = CitiesTestData.getCities()
        networkingRepositoryMock.citiesResponse = testCities

        await viewModel.fetchCitiesIfNeeded()
        
        let expectation = expectation(description: "Wait for search text updates")
        viewModel.$searchText
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { _ in
                    XCTAssertEqual(self.viewModel.filteredCities.count, 1)
                    XCTAssertEqual(self.viewModel.filteredCities.first?.name, "Hurzuf")
                    expectation.fulfill()
                }
            ).store(in: &cancellables)
        
        viewModel.searchText = "Hur"
        await fulfillment(of: [expectation], timeout: 1)
    }
}
