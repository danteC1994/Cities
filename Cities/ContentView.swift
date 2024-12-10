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
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var selectedCity: City?

    var body: some View {
        NavigationSplitView {
            CitiesListCoordinator().start(selectedCity: $selectedCity)
                .navigationTitle("Cities")
        } detail: {
            if let selectedCity {
                MapView(city: selectedCity)
                    .id(selectedCity.id)
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
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
