//
//  CitiesRepository.swift
//  Cities
//
//  Created by dante canizo on 04/12/2024.
//

import Combine
import Networking

protocol CitiesRepository {
    func fetchCities() async throws -> [City]
}
