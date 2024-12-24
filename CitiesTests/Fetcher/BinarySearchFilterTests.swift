//
//  BinarySearchFilterTests.swift
//  Cities
//
//  Created by dante canizo on 24/12/2024.
//

import XCTest
@testable import Cities

class BinarySearchFilterTests: XCTestCase {
    var filter: BinarySearchFilter!

    override func setUp() {
        super.setUp()
        filter = BinarySearchFilter()
    }

    override func tearDown() {
        filter = nil
        super.tearDown()
    }

    func test_filter_binarySearch() {
        let cities = [
            City(id: 1, name: "Amsterdam", country: "NL", coordinates: City.Coordinates(lon: 4.9041, lat: 52.3676), isFavorite: false),
            City(id: 2, name: "Berlin", country: "DE", coordinates: City.Coordinates(lon: 13.4050, lat: 52.5200), isFavorite: false),
            City(id: 3, name: "Copenhagen", country: "DK", coordinates: City.Coordinates(lon: 12.5683, lat: 55.6761), isFavorite: false)
        ]

        let index = filter.binarySearch(for: "Berlin", in: cities)

        XCTAssertNotNil(index)
        XCTAssertEqual(index, 1)
    }

    func test_filter_filterCitiesThatStartWithAGivenPrefix() {
        let cities = [
            City(id: 1, name: "Amsterdam", country: "NL", coordinates: City.Coordinates(lon: 4.9041, lat: 52.3676), isFavorite: false),
            City(id: 2, name: "Berlin", country: "DE", coordinates: City.Coordinates(lon: 13.4050, lat: 52.5200), isFavorite: false),
            City(id: 3, name: "Brussels", country: "BE", coordinates: City.Coordinates(lon: 4.3517, lat: 50.8503), isFavorite: false),
            City(id: 4, name: "Copenhagen", country: "DK", coordinates: City.Coordinates(lon: 12.5683, lat: 55.6761), isFavorite: false),
            City(id: 5, name: "London", country: "UK", coordinates: City.Coordinates(lon: -0.1278, lat: 51.5074), isFavorite: false),
            City(id: 6, name: "Luxembourg City", country: "LU", coordinates: City.Coordinates(lon: 6.1296, lat: 49.6118), isFavorite: false),
            City(id: 7, name: "Paris", country: "FR", coordinates: City.Coordinates(lon: 2.3522, lat: 48.8566), isFavorite: false),
            City(id: 8, name: "Rome", country: "IT", coordinates: City.Coordinates(lon: 12.4964, lat: 41.9028), isFavorite: false),
            City(id: 9, name: "Vienna", country: "AT", coordinates: City.Coordinates(lon: 16.3738, lat: 48.2082), isFavorite: false),
            City(id: 10, name: "Zurich", country: "CH", coordinates: City.Coordinates(lon: 8.5417, lat: 47.3769), isFavorite: false)
        ]

        let results = filter.filter(cities: cities, with: "Ber")

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Berlin")
    }

    func test_filter_returnEmptyWhenNoResultsMatchFilter() {
        let cities = [
            City(id: 1, name: "Amsterdam", country: "NL", coordinates: City.Coordinates(lon: 4.9041, lat: 52.3676), isFavorite: false),
            City(id: 2, name: "Berlin", country: "DE", coordinates: City.Coordinates(lon: 13.4050, lat: 52.5200), isFavorite: false)
        ]

        let results = filter.filter(cities: cities, with: "Xyz")

        XCTAssertTrue(results.isEmpty)
    }

    func test_filter_performanceIsLessThanPointOne() {
        let cities = (1...20000).map { index in
            City(id: index, name: "City \(index)", country: "Country", coordinates: City.Coordinates(lon: Double(index), lat: Double(index)), isFavorite: false)
        }

        var elapsedTime: TimeInterval = 0

        measure {
            let startTime = Date()

            _ = filter.filter(cities: cities, with: "City")

            elapsedTime = Date().timeIntervalSince(startTime)
        }

        XCTAssertLessThan(elapsedTime, 0.1, "Filtering should complete in less than 0.1 seconds, but took \(elapsedTime) seconds.")
    }
}
