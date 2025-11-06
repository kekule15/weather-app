//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [WeatherElement]

    struct Main: Codable {
        let temp: Double
        let feels_like: Double?
        let temp_min: Double?
        let temp_max: Double?
        let pressure: Int?
        let humidity: Int?
    }

    struct WeatherElement: Codable {
        let id: Int?
        let main: String?
        let description: String
        let icon: String?
    }
}
