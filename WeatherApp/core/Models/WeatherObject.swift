//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

struct WeatherObject: Codable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}

// MARK: - 3-Hour Forecast Models (for /forecast endpoint)

struct ForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainForecast
    let weather: [WeatherObject]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
//    let rain: Rain?
    let sys: Sys
    let dt_txt: String

    struct MainForecast: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let sea_level: Int?
        let grnd_level: Int?
        let humidity: Int
        let temp_kf: Double?
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }



    struct Sys: Codable {
        let pod: String // "d" or "n"
    }
}



struct DailySummary {
    let date: Date               // midnight of the day
    let high: Double
    let low: Double
    let description: String
    let icon: String
    let pop: Double               // max probability of precipitation
}
