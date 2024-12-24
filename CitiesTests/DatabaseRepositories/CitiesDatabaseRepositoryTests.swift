//
//  CitiesDatabaseRepositoryTests.swift
//  Cities
//
//  Created by dante canizo on 24/12/2024.
//

import XCTest
import SwiftData
@testable import Cities

class CitiesDatabaseRepositoryTests: XCTestCase {
    var repository: CitiesDatabaseRepositoryImplementation!
    var modelContainer: ModelContainer!

    override func setUp() {
        super.setUp()
        
        let schema = Schema([City.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true) // Use in-memory for testing
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            repository = CitiesDatabaseRepositoryImplementation(modelContainer: modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    override func tearDown() {
        repository = nil
        modelContainer = nil
        super.tearDown()
    }

    func test_updateCityFavorite_UpdateCitySuccessfully() async throws {
        let city = City(id: 1, name: "Hurzuf", country: "UA", coordinates: City.Coordinates(lon: 34.283333, lat: 44.549999), isFavorite: false)
        try await repository.updateCityFavorite(city) // Insert the city first

        let updatedCity = city
        updatedCity.isFavorite.toggle()
        try await repository.updateCityFavorite(updatedCity)

        let cities = try await repository.fetchCities()
        let fetchedCity = cities.first { $0.id == updatedCity.id }
        XCTAssertTrue(fetchedCity?.isFavorite == true, "The city's favorite status should be updated correctly.")
    }
    
    func test_updateCityFavorite_insertsNewCityWhenCityNotFound() async throws {
        let newCity = City(id: 2, name: "Novinki", country: "RU", coordinates: City.Coordinates(lon: 37.666668, lat: 55.683334), isFavorite: true)

        try await repository.updateCityFavorite(newCity) // This should insert since it does not exist

        let cities = try await repository.fetchCities()
        XCTAssertTrue(cities.contains(where: { $0.id == newCity.id && $0.isFavorite == true }), "New city should be inserted correctly.")
    }

    func test_fetchCities_returnsCorrectValues() async throws {
        let city1 = City(id: 3, name: "Gorkhā", country: "NP", coordinates: City.Coordinates(lon: 84.633331, lat: 28.0), isFavorite: false)
        let city2 = City(id: 4, name: "Copenhagen", country: "DK", coordinates: City.Coordinates(lon: 12.5683, lat: 55.6761), isFavorite: true)

        try await repository.updateCityFavorite(city1) // Insert city 1
        try await repository.updateCityFavorite(city2) // Insert city 2

        let cities = try await repository.fetchCities()

        XCTAssertEqual(cities.count, 2, "Should return 2 cities.")
        XCTAssertTrue(cities.contains(where: { $0.id == city1.id }), "City 1 should be present.")
        XCTAssertTrue(cities.contains(where: { $0.id == city2.id }), "City 2 should be present.")
    }

    func test_updateCityFavorite_thorwsSaveError() async throws {
        let city1 = City(id: 3, name: "Gorkhā", country: "NP", coordinates: City.Coordinates(lon: 84.633331, lat: 28.0), isFavorite: false)
        modelContainer = nil

        do {
            try await repository.updateCityFavorite(city1)
        } catch {
            XCTAssertEqual(error as? DatabaseError, DatabaseError.save)
        }
    }

    func test_fetchCities_thorwsSaveError() async throws {
        modelContainer = nil

        do {
            _ = try await repository.fetchCities()
        } catch {
            XCTAssertEqual(error as? DatabaseError, DatabaseError.query)
        }
    }
}
