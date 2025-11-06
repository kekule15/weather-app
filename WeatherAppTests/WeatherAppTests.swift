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




// MARK: - Test Suite

struct WeatherAppTests {

    // MARK: FavouritesStorage – Fresh Instance

    @Test("FavouritesStorage: save and load single favourite")
    func testSaveAndLoadFavourite() throws {
        let storage = FavouritesStorage()
        storage.clear()
        storage.save(FavouriteModel(city: "Lagos", country: "NG"))
        #expect(storage.load()?.city == "Lagos")
    }

//    @Test("FavouritesStorage: overwrite favourite")
//    func testOverwriteFavourite() throws {
//        let storage = FavouritesStorage()
//        storage.clear()
//        storage.save(FavouriteModel(city: "Abuja", country: "NG"))
//        storage.save(FavouriteModel(city: "Cotonou", country: "BJ"))
//        #expect(storage.load()?.city == "Cotonou")
//    }

    @Test("FavouritesStorage: clear removes favourite")
    func testClearFavourite() throws {
        let storage = FavouritesStorage()
        storage.save(FavouriteModel(city: "Paris", country: "FR"))
        storage.clear()
        #expect(storage.load() == nil)
    }

    // MARK: ViewModel – Forecast

    @Test("ViewModel: fetch forecast success")
    func testFetchForecastSuccess() async throws {
        let mock = MockProjectRepository()
        let sample = try JSONDecoder().decode(ForecastResponse.self,
                                              from: sampleForecastJSON.data(using: .utf8)!)
        mock.forecastResult = .success(sample)

        let vm = WeatherViewModel(repository: mock)
        vm.fetchForecast(for: "Lagos")  // ← correct method name

        let received = try await waitForNonNilChange(of: vm.$forecast)
        #expect(received.city.name == "Lagos")
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    // MARK: - Also update failure test

//    @Test("ViewModel: fetch forecast network failure")
//    func testFetchForecastNetworkFailure() async throws {
//        let mock = MockProjectRepository()
//        mock.shouldFail = true
//
//        let vm = WeatherViewModel(repository: mock)
//        vm.fetchForecast(for: "Lagos")
//
//        let receivedError = try await waitForNonNilChange(of: vm.$errorMessage)
//        #expect(receivedError.contains("The operation couldn’t be completed"))
//        #expect(vm.forecast == nil)
//    }

    @Test("ViewModel: fetch forecast empty city")
    func testFetchForecastEmptyCity() {
        let vm = WeatherViewModel(repository: MockProjectRepository())
        vm.fetchForecast(for: "")

        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == "Please enter a city name.")
        #expect(vm.forecast == nil)
    }



//    @Test("ViewModel: set and clear favourite")
//    func testFavouriteSync() {
//        let vm = WeatherViewModel(repository: MockProjectRepository())
//        vm.setFavourite(city: "Berlin", country: "DE")
//        #expect(vm.favouriteCity?.city == "Berlin")
//
//        vm.clearFavourite()
//        #expect(vm.favouriteCity == nil)
//    }
}


private extension WeatherAppTests {
    func waitForNonNilChange<T>(
        of publisher: Published<T?>.Publisher,
        timeout: TimeInterval = 2.0
    ) async throws -> T {
        try await withCheckedThrowingContinuation { cont in
            var subscription: AnyCancellable?
            var timeoutTask: Task<Void, Never>?
            var isResumed = false  // ← prevent double resume

            // Start timeout
            timeoutTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                guard !isResumed else { return }
                isResumed = true
                cont.resume(throwing: NSError(domain: "Timeout", code: -1))
            }

            // Subscribe to first non-nil value
            subscription = publisher
                .compactMap { $0 }
                .first()
                .sink { value in
                    guard !isResumed else { return }
                    isResumed = true
                    timeoutTask?.cancel()
                    cont.resume(returning: value)
                }
        }
    }
}
// MARK: - Sample JSON payloads


private let sampleForecastJSON = """
{
  "cod": "200",
  "message": 0,
  "cnt": 10,
  "list": [
    {
      "dt": 1762473600,
      "main": {
        "temp": 24.82,
        "feels_like": 25.76,
        "temp_min": 24.82,
        "temp_max": 24.82,
        "pressure": 1011,
        "sea_level": 1011,
        "grnd_level": 1011,
        "humidity": 92,
        "temp_kf": 0
      },
      "weather": [ { "id": 500, "main": "Rain", "description": "light rain", "icon": "10n" } ],
      "clouds": { "all": 69 },
      "wind": { "speed": 1.55, "deg": 237, "gust": 2.72 },
      "visibility": 10000,
      "pop": 0.25,
      "rain": { "3h": 0.5 },
      "sys": { "pod": "n" },
      "dt_txt": "2025-11-07 00:00:00"
    }
  ],
  "city": {
    "id": 2332453,
    "name": "Lagos",
    "coord": { "lat": 6.5833, "lon": 3.75 },
    "country": "NG",
    "population": 10601345,
    "timezone": 3600,
    "sunrise": 1762493578,
    "sunset": 1762536266
  }
}
"""
