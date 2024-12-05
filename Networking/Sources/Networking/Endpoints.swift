//
//  Endpoints.swift
//  Networking
//
//  Created by dante canizo on 02/12/2024.
//

import Foundation

public enum Endpoint {
    case cities

    var urlString: String {
        switch self {
        case .cities: return "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        }
    }
}
