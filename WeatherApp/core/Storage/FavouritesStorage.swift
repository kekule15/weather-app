//
//  FavouritesStorage.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//


import Foundation


final class FavouritesStorage {
    private let key = "favourite_city_v1"
    private let defaults = UserDefaults.standard
    
    /// Returns the **single** favourite city (or nil)
    func load() -> FavouriteModel? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(FavouriteModel.self, from: data)
    }
    
    /// Saves a favourite (overwrites any previous one)
    func save(_ favourite: FavouriteModel) {
        if let data = try? JSONEncoder().encode(favourite) {
            defaults.set(data, forKey: key)
        }
    }
    
    /// Removes the favourite
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
