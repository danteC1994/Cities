//
//  CitiesListView.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import SwiftUI

struct CitiesListView: View {
    @StateObject var viewModel: CitiesListViewModel
    @State private(set) var currentSelectedCity: City? = nil
    let selectedCity: City?
    @State private var searchText = ""
    private(set) var onSelectedCity: ((_ city: City?) -> Void)?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.citiesToDisplay.indices, id: \.self) { index in
                    Button(action: {
                        currentSelectedCity = viewModel.citiesToDisplay[index]
                        
                    }) {
                        HStack {
                            Text("\(viewModel.citiesToDisplay[index].name), \(viewModel.citiesToDisplay[index].country)")
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding()
                    }
                    .background(index.isMultiple(of: 2) ? Color.clear : Color.gray.opacity(0.2))
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onAppear {
                        if viewModel.citiesToDisplay[index] == viewModel.citiesToDisplay.last {
                            viewModel.reachLastElement()
                        }
                    }
                    
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $viewModel.searchText)
        }
        .task {
            await viewModel.fetchCities()
        }
        .onChange(of: currentSelectedCity) { _, newValue in
            guard let newValue else { return }
            onSelectedCity?(newValue)
        }
    }
}

extension CitiesListView {
    func onSelectedCity(action: @escaping (_ city: City?) -> Void) -> CitiesListView {
        var copy = self
        copy.onSelectedCity = action
        return copy
    }
}

#Preview {
    NavigationView {
//        CitiesListCoordinator().start(selectedCity: .constant(nil))
    }
}
