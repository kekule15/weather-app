//
//  City.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

struct City: Codable {
    let coord: Coord
    let country: String
    let id: Int
    let name: String
    let population: Int?
    let timezone: Int?
}
