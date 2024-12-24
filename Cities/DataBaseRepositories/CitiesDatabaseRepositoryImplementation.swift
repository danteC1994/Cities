//
//  CitiesDatabaseRepositoryImplementation.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

import SwiftData
import Foundation

final class CitiesDatabaseRepositoryImplementation: CitiesDatabaseRepository {
    let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    @MainActor
    func updateCityFavorite(_ city: City) async throws {
        do {
            let cities = try await fetchCities()
            
            guard let storedCity = cities.first(where: { $0.id == city.id }) else {
                try insert(city)
                return
            }
            storedCity.isFavorite = city.isFavorite
            try save()
        } catch {
            throw DatabaseError.save
        }
    }

    @MainActor
    func fetchCities() async throws -> [City] {
        let cityDescriptor = FetchDescriptor<City>()
        do {
            let cities = try modelContainer.mainContext.fetch(cityDescriptor)
            return cities
        } catch {
            throw DatabaseError.query
        }
    }

    @MainActor
    private func insert<T>(_ model: T) throws where T : PersistentModel {
        modelContainer.mainContext.insert(model)
        try save()
    }

    @MainActor
    private func save() throws {
        do {
            try modelContainer.mainContext.save()
        } catch {
            throw DatabaseError.save
        }
    }
}
