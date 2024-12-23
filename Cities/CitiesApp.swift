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
    @StateObject private var router = Router(viewFactory: .init(environment: .stage))

    var body: some Scene {
        WindowGroup {
            ContentView(shouldShowMap: false)
                .environmentObject(router)
        }
        .modelContainer(PersistenceManager.shared.sharedModelContainer)
    }
}
