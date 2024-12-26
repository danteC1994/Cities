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

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            if ProcessInfo.processInfo.environment["IS_MAIN_APP"] != nil {
                ContentView(shouldShowMap: false)
                    .environmentObject(router)
            } else if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
                EmptyView()
            } else {
                ContentView(shouldShowMap: false)
                    .environmentObject(Router(viewFactory: .init(environment: .stage)))
            }
            #else
            ContentView(shouldShowMap: false)
                .environmentObject(router)
            
            #endif
        }
        .modelContainer(PersistenceManager.shared.sharedModelContainer)
    }
}
