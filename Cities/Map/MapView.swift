//
//  MapView.swift
//  Cities
//
//  Created by dante canizo on 09/12/2024.
//

import MapKit
import SwiftUI

struct MapView: View {
    var city: City?

    var body: some View {
        if let city {
            ZStack {
                let region = MKCoordinateRegion(
                    center: .init(latitude: city.coordinates.lat, longitude: city.coordinates.lon),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                Map(coordinateRegion: .constant(region), showsUserLocation: false, userTrackingMode: nil, annotationItems: [city]) { city in
                    MapAnnotation(coordinate: .init(latitude: city.coordinates.lat, longitude: city.coordinates.lon)) {
                        VStack {
                            Image(systemName: "mappin")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                                .frame(width: 30, height: 30)
                            Text(city.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    MapView(city: .init(id: 3, name: "Hurzuf", country: "UA", coordinates: .init(lon: 34.283333, lat: 44.549999)))
}
