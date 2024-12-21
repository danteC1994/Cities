//
//  CItiesDatabaseRepositoryMock.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

class CItiesDatabaseRepositoryMock: CitiesDatabaseRepository {
    func fetchCities() async throws -> [City] {
        return CitiesTestData.getCities()
    }
    
    func updateCityFavorite(_ city: City) async throws {
        assertionFailure("Not implemented yet")
    }
}
