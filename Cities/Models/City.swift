//
//  City.swift
//  Cities
//
//  Created by dante canizo on 03/12/2024.
//

struct City: Identifiable, Codable {
    let id: Int
    let name: String
    let country: String
    let coordinates: Coordinates
    
    var favorite: Bool = false
    
    struct Coordinates: Codable {
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
