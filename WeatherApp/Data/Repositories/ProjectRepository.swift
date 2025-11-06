//
//  ProjectRepository.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//


import Foundation
import Alamofire

final class ProjectRepository: ProjectBaseRepository {

    private let api: ApiManager

    init(api: ApiManager) {
        self.api = api
    }

    // MARK: - Current weather
    func fetchCurrentWeather(for city: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "q": city,
            "appid": NetworkConstants.apiKey,
            "units": "metric"
        ]

        api.get("/weather", params: params) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1)))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
                    print(" API Success: \(decoded)")
                    completion(.success(decoded))
                } catch {
                    print(" Decoding failed:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Forecast (Daily)
    func fetchWeatherForecast(for city: String, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "q": city,
            "appid": NetworkConstants.apiKey,
            "units": "imperial", //imperial and metrics
            "cnt": 40 //Critical: 40 = 5 days × 8 (3-hour intervals)
        ]

        api.get("/forecast", params: params) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(NSError(domain: "NoData", code: -1)))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    print("API Success: \(decoded)")
                    completion(.success(decoded))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("API error: \(error)")
                completion(.failure(error))
            }
        }
    }
}



