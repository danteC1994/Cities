//
//  CitiesDatabaseRepository.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

protocol CitiesDatabaseRepository {
    func fetchCities() async throws -> [City]
    func updateCityFavorite(_ city: City) async throws
}
