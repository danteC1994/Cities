//
//  CityTests.swift
//  Cities
//
//  Created by dante canizo on 24/12/2024.
//

import XCTest
@testable import Cities

class CityTests: XCTestCase {
    func test_cityInitialization() {
        let coordinates = City.Coordinates(lon: 34.283333, lat: 44.549999)
        let city = City(id: 1, name: "Hurzuf", country: "UA", coordinates: coordinates, isFavorite: false)

        XCTAssertEqual(city.id, 1)
        XCTAssertEqual(city.name, "Hurzuf")
        XCTAssertEqual(city.country, "UA")
        XCTAssertEqual(city.coordinates.lon, 34.283333)
        XCTAssertEqual(city.coordinates.lat, 44.549999)
        XCTAssertFalse(city.isFavorite)
    }

    func test_cityCodable() throws {
        let coordinates = City.Coordinates(lon: 34.283333, lat: 44.549999)
        let city = City(id: 1, name: "Hurzuf", country: "UA", coordinates: coordinates, isFavorite: false)

        let encoder = JSONEncoder()
        let data = try encoder.encode(city)
        
        let decoder = JSONDecoder()
        let decodedCity = try decoder.decode(City.self, from: data)

        XCTAssertEqual(decodedCity.id, city.id)
        XCTAssertEqual(decodedCity.name, city.name)
        XCTAssertEqual(decodedCity.country, city.country)
        XCTAssertEqual(decodedCity.coordinates.lon, city.coordinates.lon)
        XCTAssertEqual(decodedCity.coordinates.lat, city.coordinates.lat)
        XCTAssertEqual(decodedCity.isFavorite, city.isFavorite)
    }

    func test_cityHashable() {
        let coordinates1 = City.Coordinates(lon: 34.283333, lat: 44.549999)
        let city1 = City(id: 1, name: "Hurzuf", country: "UA", coordinates: coordinates1, isFavorite: false)
        
        let coordinates2 = City.Coordinates(lon: 37.666668, lat: 55.683334)
        let city2 = City(id: 2, name: "Novinki", country: "RU", coordinates: coordinates2, isFavorite: true)

        // Create a set to check if cities are uniquely hashable
        let citiesSet: Set<City> = [city1, city2]

        XCTAssertTrue(citiesSet.contains(city1))
        XCTAssertTrue(citiesSet.contains(city2))
        XCTAssertEqual(citiesSet.count, 2)
    }

    func test_cityComparable() {
        let coordinates1 = City.Coordinates(lon: 34.283333, lat: 44.549999)
        let city1 = City(id: 1, name: "A City", country: "UA", coordinates: coordinates1, isFavorite: false)

        let coordinates2 = City.Coordinates(lon: 37.666668, lat: 55.683334)
        let city2 = City(id: 2, name: "B City", country: "RU", coordinates: coordinates2, isFavorite: true)

        XCTAssertTrue(city1 < city2)
    }
}
