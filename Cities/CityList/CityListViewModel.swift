//
//  CityListViewModel.swift
//  Cities
//
//  Created by dante canizo on 03/12/2024.
//

import Combine
import Foundation
import Networking

final class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
    let apiClient: APIClient
    
    init() {
        apiClient = APIClient(baseURL: URL(string: "https://gist.githubusercontent.com/")!)
    }

    func fetchCities() async {
        do {
            cities = try await apiClient.get(endpoint: .cities, headers: nil)
        } catch {
            print(error)
        }
    }
}
