//
//  Result.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 26/06/22.
//

import Foundation

struct Result: Codable {
    let weather: [Weather]
    let coord: Coord
    let main: Main

}
