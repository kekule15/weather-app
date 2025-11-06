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

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
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
                    let resp = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(resp))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

