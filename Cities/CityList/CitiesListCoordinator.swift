//
//  CitiesListCoordinator.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import Networking
import SwiftUI

final class CitiesListCoordinator {
    func start(with client : APIClientProtocol? = nil) -> some View {
        let apiClient: APIClientProtocol = client ?? APIClient(baseURL: URL(string: "https://gist.githubusercontent.com/")!)
        let repository = CitiesRepositoryImplementation(apiClient: apiClient)
        let viewModel = CitiesListViewModel(repository: repository)
        let view = CitiesListView(viewModel: viewModel)
        return view
    }
}
