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
        VStack {
            if viewModel.loading {
                ProgressView()
            } else if let error = viewModel.error {
                errorView(error)
            } else {
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
    NavigationView {
//        CitiesListCoordinator().start(selectedCity: .constant(nil))
    }
}
