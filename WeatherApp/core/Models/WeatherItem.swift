//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

struct WeatherItem: Codable {
    let clouds: Int?
    let deg: Int?
    let dt: Int
    let feels_like: FeelsLike?
    let gust: Double?
    let humidity: Int?
    let pop: Double?
    let pressure: Int?
    let speed: Double?
    let sunrise: Int?
    let sunset: Int?
    let temp: Temp?
    let weather: [WeatherObject]
}
