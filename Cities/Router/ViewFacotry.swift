//
//  Route.swift
//  Cities
//
//  Created by dante canizo on 17/12/2024.
//

import Networking
import SwiftUI

struct ViewFactory {
    enum Environment {
        case stage
        case production
    }
    
    private let apiClient: APIClient
    private let environment: Environment
    
    init(environment: Environment = .production) {
        self.environment = environment
        switch environment {
        case .stage:
            apiClient = APIClientMock()
        case .production:
            apiClient = APIClientImplementation(baseURL: URL(filePath: "https://gist.githubusercontent.com/"))
        }
    }
    
    @ViewBuilder
    func createView(for route: Route) -> some View {
        switch route {
        case let .citiesListNavigation(selectedCity, onSelectedCity):
            makeNavigationView(selectedCity: selectedCity, onSelectedCity: onSelectedCity)
        case let .citiesList(selectedCity, onSelectedCity):
            makeCitiesListView(selectedCity: selectedCity, onSelectedCity: onSelectedCity)
        case let .map(city):
            makeMapView(city: city)
        }
    }

    @ViewBuilder
    func makeNavigationView(selectedCity: City?, onSelectedCity: @escaping (City?) -> Void) -> some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            NavigationStack {
                makeCitiesListView(selectedCity: selectedCity, onSelectedCity: onSelectedCity)
            }
        case .pad:
            NavigationSplitView {
                makeCitiesListView(selectedCity: selectedCity, onSelectedCity: onSelectedCity)
            } detail: {
                if let selectedCity {
                    makeMapView(city: selectedCity)
                } else {
                    Text("Select a city to view its location")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
        default:
            NavigationSplitView {
                makeCitiesListView(selectedCity: selectedCity, onSelectedCity: onSelectedCity)
            } detail: {
                if let selectedCity {
                    makeMapView(city: selectedCity)
                } else {
                    Text("Select a city to view its location")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    func makeCitiesListView(selectedCity: City?, onSelectedCity: @escaping (City?) -> Void) -> CitiesListView {
        switch environment {
        case .production:
            return CitiesListView(
                viewModel: .init(
                    repository: CitiesRepositoryImplementation(apiClient: apiClient)
                ),
                selectedCity: selectedCity
            )
            .onSelectedCity(action: onSelectedCity)
        case .stage:
            return CitiesListView(
                viewModel: .init(
                    repository: CitiesRepositoryImplementation(apiClient: apiClient)
                ),
                selectedCity: selectedCity
            )
            .onSelectedCity(action: onSelectedCity)
        }
    }

    func makeMapView(city: City?) -> MapView {
        switch environment {
        case .production:
            return MapView(
                city: city
            )
        case .stage:
            return MapView(
                city: city
            )
        }
    }
}
