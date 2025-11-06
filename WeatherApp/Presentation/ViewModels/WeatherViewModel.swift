//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//


import Foundation
import Combine

final class WeatherViewModel : ObservableObject {
    // Published state
    @Published private(set) var currentWeather: CurrentWeatherResponse?
    @Published private(set) var forecast: ForecastResponse?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private let repository: ProjectBaseRepository
    private let favourites = FavouritesStorage()
    private var cancellables = Set<AnyCancellable>()

    init(repository: ProjectBaseRepository) {
        self.repository = repository
    }

    // Fetch current weather
    func fetchCurrentWeather(for city: String) {
        guard !city.isEmpty else {
            self.errorMessage = "Please enter a city name."
            return
        }

        isLoading = true
        repository.fetchCurrentWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let resp):
                    self.currentWeather = resp
                    self.errorMessage = nil
                case .failure(let err):
                    self.currentWeather = nil
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }

    // Fetch forecast (list)
    func fetchForecast(for city: String) {
        guard !city.isEmpty else {
            self.errorMessage = "Please enter a city name."
            return
        }

        isLoading = true
        repository.fetchWeatherForecast(for: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let resp):
                    self.forecast = resp
                    self.errorMessage = nil
                case .failure(let err):
                    self.forecast = nil
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
    
    var favouriteCity: FavouriteModel? { favourites.load() }
        
        func setFavourite(city: String, country: String?) {
            favourites.save(FavouriteModel(city: city, country: country))
        }
        
        func clearFavourite() { favourites.clear() }
}

