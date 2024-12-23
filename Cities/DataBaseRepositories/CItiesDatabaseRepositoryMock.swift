//
//  CItiesDatabaseRepositoryMock.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

class CItiesDatabaseRepositoryMock: CitiesDatabaseRepository {
    var error: DatabaseError?

    init(error: DatabaseError? = .query) {
        self.error = error
    }

    func fetchCities() async throws -> [City] {
        return CitiesTestData.getCities()
    }
    
    func updateCityFavorite(_ city: City) async throws {
        if let error {
            throw error
        }
    }
}
