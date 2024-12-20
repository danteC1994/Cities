//
//  CitiesTestData.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

final class CitiesTestData {
    static func getCities() -> [City] {
        [
            City(
                id: 707860,
                name: "Hurzuf",
                country: "UA",
                coordinates: City.Coordinates(lon: 34.283333, lat: 44.549999)
            ),
            City(
                id: 519188,
                name: "Novinki",
                country: "RU",
                coordinates: City.Coordinates(lon: 37.666668, lat: 55.683334)
            ),
            City(
                id: 1283378,
                name: "Gorkhā",
                country: "NP",
                coordinates: City.Coordinates(lon: 84.633331, lat: 28.0)
            )
        ]
    }
}
