//
//  Weather.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 26/06/22.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    var iconUrl: URL {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: urlString)!
    }
    
}
