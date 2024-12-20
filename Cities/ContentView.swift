//
//  ContentView.swift
//  Cities
//
//  Created by dante canizo on 01/12/2024.
//

import Networking
import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var selectedCity: City?
    @State var shouldShowMap: Bool

    var body: some View {
        mainContent()
    }

    @ViewBuilder
    private func mainContent() -> some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            phoneNavigation
        case .pad:
            padNavigation
        default:
            padNavigation
        }
    }

    private var phoneNavigation: some View {
        NavigationStack {
            router.push(
                route: .citiesList(
                    selectedCity: nil) { city in
                        selectedCity = city
                        shouldShowMap = true
                    }
            )
            .navigationDestination(isPresented: $shouldShowMap) {
                router.push(route: .map(city: selectedCity))
            }
        }
    }

    private var padNavigation: some View {
        NavigationSplitView {
            router.push(
                route: .citiesList(
                    selectedCity: nil) { city in
                        selectedCity = city
                        shouldShowMap = true
                    }
            )
            .navigationDestination(isPresented: $shouldShowMap) {
                router.push(route: .map(city: selectedCity))
            }
        } detail: {
            if let selectedCity {
                router.push(route: .map(city: selectedCity))
            } else {
                Text("Select a city to view its location")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    let router = Router(
        viewFactory: .init(
            environment: .stage
        )
    )

    ContentView(shouldShowMap: false)
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(router)
}
