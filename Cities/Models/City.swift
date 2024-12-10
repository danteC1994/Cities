//
//  City.swift
//  Cities
//
//  Created by dante canizo on 03/12/2024.
//

struct City: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let country: String
    let coordinates: Coordinates
    
    var favorite: Bool = false
    
    struct Coordinates: Codable, Hashable {
        let lon: Double
        let lat: Double
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coordinates = "coord"
    }
}
extension City: Comparable {
    var sortableName: String {
        name + country
    }

    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: City, rhs: City) -> Bool {
        lhs.sortableName.lowercased() < rhs.sortableName.lowercased()
    }
}
