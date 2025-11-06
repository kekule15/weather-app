//
//  ProjectBaseRepository.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

protocol ProjectBaseRepository {
    func fetchWeather(for city: String, completion: @escaping (WeatherResponse?) -> Void)
}
