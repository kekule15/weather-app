//
//  DIContainer.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Factory

extension Container {
    // ApiManager factory: singleton-ish for convenience
    var apiManager: Factory<ApiManager> {
        Factory(self) {
            ApiManager()
        }
    }

    // Repository factory that depends on apiManager
    var projectRepository: Factory<ProjectBaseRepository> {
        Factory(self) {
            // note: cast concrete implementation to protocol
            return ProjectRepository(api: self.apiManager()) as ProjectBaseRepository
        }
    }

    // ViewModel factory (returns fully constructed view model)
//    var weatherViewModel: Factory<WeatherViewModel> {
//        Factory(self) {
//            WeatherViewModel(repository: self.projectRepository())
//        }
//    }
    var weatherViewModel: Factory<WeatherViewModel> {
        Factory(self) { WeatherViewModel(repository: self.projectRepository()) }.shared
    }

}
