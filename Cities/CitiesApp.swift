//
//  CitiesApp.swift
//  Cities
//
//  Created by dante canizo on 01/12/2024.
//

import SwiftUI
import SwiftData

@main
struct CitiesApp: App {
    @StateObject private var router = Router(viewFactory: .init(environment: .production))

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(shouldShowMap: false)
                .environmentObject(router)
        }
        .modelContainer(sharedModelContainer)
    }
}
