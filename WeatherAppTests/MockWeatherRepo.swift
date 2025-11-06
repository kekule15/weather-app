//
//  MockWeatherRepo.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation
import Testing
import Combine
@testable import WeatherApp

// MARK: - Mock Repository conforming to the real protocol

final class MockProjectRepository: ProjectBaseRepository {
    var currentWeatherResult: Result<CurrentWeatherResponse, Error>?
    var forecastResult: Result<ForecastResponse, Error>?
    var shouldFail = false

    func fetchCurrentWeather(
        for city: String,
        completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void
    ) {
        if shouldFail {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        if let result = currentWeatherResult {
            completion(result)
            return
        }
        completion(.failure(URLError(.unknown)))
    }

    func fetchWeatherForecast(
        for city: String,
        completion: @escaping (Result<ForecastResponse, Error>) -> Void
    ) {
        if shouldFail {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        if let result = forecastResult {
            completion(result)
            return
        }
        completion(.failure(URLError(.unknown)))
    }
}




