//
//  CitiesListView.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import SwiftUI

struct CitiesListView: View {
    @StateObject var viewModel: CitiesListViewModel
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.cities.indices, id: \.self) { index in
                    HStack {
                        Text("\(viewModel.cities[index].name), \(viewModel.cities[index].country)")
                            .padding()
                        Spacer()
                    }
                    .background(index.isMultiple(of: 2) ? Color.clear : Color.gray.opacity(0.2))
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchText)
            .task {
                await viewModel.fetchCities()
            }
        }
    }
}

#Preview {
    CitiesListCoordinator().start()
}
