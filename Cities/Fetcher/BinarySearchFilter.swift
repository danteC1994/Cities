//
//  BinarySearchImplementation.swift
//  Cities
//
//  Created by dante canizo on 18/12/2024.
//

final class BinarySearchFilter: ArrayFilter {
    typealias T = City

    func filter(cities: [City], with prefix: String) -> [City] {
        return filterCitiesThatStartWith(prefix: prefix, in: cities)
    }

    func binarySearch(for prefix: String, in cities: [City]) -> Int? {
        var low = 0
        var high = cities.count - 1
        
        while low <= high {
            let mid = (low + high) / 2
            let midCity = cities[mid].name.lowercased()

            if midCity.hasPrefix(prefix.lowercased()) {
                return mid
            } else if midCity < prefix.lowercased() {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }

        return nil
    }

    func filterCitiesThatStartWith(prefix: String, in cities: [City]) -> [City] {
        guard let startIndex = binarySearch(for: prefix, in: cities) else {
            return []
        }
        
        var results: [City] = []
        
        var index = startIndex
        while index < cities.count && cities[index].name.lowercased().hasPrefix(prefix.lowercased()) {
            results.append(cities[index])
            index += 1
        }
        
        return results
    }
}
