//
//  ArrayFilterTypeErasure.swift
//  Cities
//
//  Created by dante canizo on 19/12/2024.
//

// Array Filter type erasure
final class AnyArrayFilter<T: Comparable>: ArrayFilter {
    private let _filter: ([T], String) -> [T]
    
    init<U: ArrayFilter>(_ arrayFilter: U) where U.T == T {
        self._filter = arrayFilter.filter
    }
    
    func filter(cities: [T], with prefix: String) -> [T] {
        return _filter(cities, prefix)
    }
}
