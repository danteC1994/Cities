//
//  CitiesListView.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import SwiftUI

struct CitiesListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: CitiesListViewModel
    @State private(set) var currentSelectedCity: City? = nil
    let selectedCity: City?
    @State private var searchText = ""
    private(set) var onSelectedCity: ((_ city: City?) -> Void)?
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else if let error = viewModel.error {
                errorView(error)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.citiesToDisplay, id: \.id) { city in
                            Button(action: {
                                currentSelectedCity = city
                            }) {
                                HStack {
                                    Text("\(city.name), \(city.country)")
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Button(action: {
                                        Task {
                                            await viewModel.toggleFavorite(for: city)
                                        }
                                    }) {
                                        Image(systemName: city.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(city.isFavorite ? .yellow : .gray)
                                    }
                                }
                                .padding()
                            }
                            .background(Color.gray.opacity(0.1))
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                        }
                    }
                    .listStyle(PlainListStyle())
                    .searchable(text: $viewModel.searchText)
                }
            }
        }
        .task {
            await viewModel.fetchCities()
        }
        .onChange(of: currentSelectedCity) { _, newValue in
            guard let newValue else { return }
            onSelectedCity?(newValue)
        }
    }

    private func errorView(_ error: UIError) -> some View {
        switch error {
        case .recoverableError(title: let title, description: let description, actionTitle: let actionTitle):
            GenericErrorView(
                title: title,
                description: description,
                actionTitle: actionTitle,
                action: {
                    Task {
                        await viewModel.fetchCities()
                    }
                }
            )
        case .nonRecoverableError(title: let title, description: let description, actionTitle: let actionTitle):
            GenericErrorView(
                title: title,
                description: description,
                actionTitle: actionTitle,
                action: {
                    Task {
                        await viewModel.fetchCities()
                    }
                }
            )
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
    @Previewable @State var selectedCity: City?
    @Previewable @State var shouldShowMap: Bool = false

    let router = Router(
        viewFactory: .init(
            environment: .stage
        )
    )

    NavigationStack {
        router.push(
            route: .citiesList(selectedCity: nil) { city in
                selectedCity = city
                shouldShowMap = true
            }
        )
        .navigationDestination(isPresented: $shouldShowMap) {
            router.push(route: .map(city: selectedCity))
        }
    }
}
