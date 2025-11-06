//
//  ProjectBaseRepository.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

protocol ProjectBaseRepository {
    // Current weather ( /weather )
    func fetchCurrentWeather(for city: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void)

    // Forecast / list (e.g. 5 day / forecast or custom endpoint)
    func fetchWeatherForecast(for city: String, completion: @escaping (Result<ForecastResponse, Error>) -> Void)
}
