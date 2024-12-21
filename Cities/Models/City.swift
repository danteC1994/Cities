//
//  City.swift
//  Cities
//
//  Created by dante canizo on 03/12/2024.
//

import SwiftData

@Model
class City: Identifiable, Codable, Hashable {
    @Attribute(.unique) var id: Int
    var name: String
    var country: String
    var coordinates: Coordinates

    var isFavorite: Bool = false

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

    init(id: Int, name: String, country: String, coordinates: Coordinates, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.country = country
        self.coordinates = coordinates
        self.isFavorite = isFavorite
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        try container.encode(coordinates, forKey: .coordinates)
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
