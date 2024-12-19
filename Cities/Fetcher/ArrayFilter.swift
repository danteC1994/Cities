//
//  ArrayFetcher.swift
//  Cities
//
//  Created by dante canizo on 18/12/2024.
//

protocol ArrayFilter {
    associatedtype T: Comparable

    func filter(cities: [T], with prefix: String) -> [T]
}
