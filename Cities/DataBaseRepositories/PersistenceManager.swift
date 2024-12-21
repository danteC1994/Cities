//
//  PersistenceManager.swift
//  Cities
//
//  Created by dante canizo on 21/12/2024.
//

import SwiftData

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            City.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
