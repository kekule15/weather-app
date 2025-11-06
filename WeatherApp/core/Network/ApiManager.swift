//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation
import Alamofire

final class ApiManager {
    
    private let session: Session
    private let baseURL: String
    
    init(baseURL: String = NetworkConstants.baseURL) {
        self.baseURL = baseURL
        self.session = Session.default
    }
    
    func get(
        _ route: String,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        let url = "\(baseURL)\(route)"
        print("API url: \(url)")
        session.request(url, method: .get, parameters: params, headers: headers)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
    
    func post(
        _ route: String,
        body: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        let url = "\(baseURL)\(route)"
        session.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                completion(response.result)
            }
    }
}
