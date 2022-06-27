//
//  MapView+Extensions.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 26/06/22.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 7000) {
        let coordinateRegion = MKCoordinateRegion (center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
