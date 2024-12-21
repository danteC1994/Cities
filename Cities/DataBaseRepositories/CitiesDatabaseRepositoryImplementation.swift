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
            
            guard let city = cities.first(where: { $0.id == city.id }) else {
                insert(city)
                return
            }
            
            city.isFavorite.toggle()
        } catch {
            print(error)
        }
    }

    @MainActor
    func fetchCities() async throws -> [City] {
        let cityDescriptor = FetchDescriptor<City>()
        do {
            let cities = try modelContainer.mainContext.fetch(cityDescriptor)
            return cities
        } catch {
            print(error)
            return []
        }
    }

    @MainActor
    private func insert<T>(_ model: T) where T : PersistentModel {
        modelContainer.mainContext.insert(model)
        do {
            try modelContainer.mainContext.save()
        } catch {
            
        }
    }
}
