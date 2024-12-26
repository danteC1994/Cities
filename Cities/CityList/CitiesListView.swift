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
                    .accessibilityIdentifier("Progress")
            } else if let error = viewModel.error {
                errorView(error)
            } else {
                citiesList
            }
        }
        .task {
            await viewModel.fetchCitiesIfNeeded()
        }
        .refreshable {
            await viewModel.refreshCities()
        }
        .overlay(
            ToastView(message: viewModel.toastMessage, isShowing: $viewModel.showToast)
                .padding(),
            alignment: .bottom
        )
    }

    private var citiesList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.citiesToDisplay, id: \.id) { city in
                    cityRow(city)
                    .background(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .padding(.horizontal)
                    .accessibilityIdentifier("\(city.name), \(city.country)")
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $viewModel.searchText)
        }
    }

    private func cityRow(_ city: City) -> some View {
        Button(action: {
            currentSelectedCity = city
            onSelectedCity?(city)
        }) {
            HStack {
                Text("\(city.name), \(city.country)")
                    .foregroundStyle(.black)
                Spacer()
                saveButton(city)
            }
            .padding()
        }
        .accessibilityIdentifier("\(city.name)_button")
    }

    private func saveButton(_ city: City) -> some View {
        Button(action: {
            Task {
                await viewModel.toggleFavorite(for: city)
            }
        }) {
            saveImage(city)
        }
        .accessibilityIdentifier(city.isFavorite ? "\(city.name)_saved" : "\(city.name)_notSaved")
    }

    private func saveImage(_ city: City) -> some View {
        Image(systemName: city.isFavorite ? "star.fill" : "star")
            .accessibilityIdentifier(city.isFavorite ? "star.fill" : "star")
            .foregroundColor(city.isFavorite ? .yellow : .gray)
    }

    @ViewBuilder
    private func errorView(_ error: UIError) -> some View {
        switch error {
        case .recoverableError(title: let title, description: let description, actionTitle: let actionTitle):
            GenericErrorView(
                title: title,
                description: description,
                actionTitle: actionTitle,
                action: {
                    Task {
                        await viewModel.refreshCities()
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
                        await viewModel.refreshCities()
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
