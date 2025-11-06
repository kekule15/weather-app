//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

struct WeatherModel: Codable {
    let city: City
    let cnt: Int?
    let cod: String?
    let list: [WeatherItem]
    let message: Double?
}
