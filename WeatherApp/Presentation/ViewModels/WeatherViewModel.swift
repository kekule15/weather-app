//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

final class WeatherViewModel {
    private let repository: ProjectBaseRepository

    private(set) var weather: WeatherResponse?
    var onUpdate: (() -> Void)?

    init(repository: ProjectBaseRepository) {
        self.repository = repository
    }

    func fetchWeather(for city: String) {
        repository.fetchWeather(for: city) { [weak self] result in
            switch result {
            case .success(let resp):
                self?.weather = resp
            case .failure:
                self?.weather = nil
            }
            DispatchQueue.main.async {
                self?.onUpdate?()
            }
        }
    }
}
