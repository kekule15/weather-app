//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import UIKit
import Combine
import Factory  

final class HomeViewController: UIViewController {
    // MARK: UI
    private let cityField      = UITextField()
    private let getButton      = UIButton(type: .system)
    private let spinner        = UIActivityIndicatorView(style: .medium)
    
    // MARK: DI
    @Injected(\.weatherViewModel) private var vm: WeatherViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildUI()
        bindVM()
        prefillFavourite()
    }
    
    // MARK: UI (pure code)
    private func buildUI() {
        // City field
        cityField.placeholder = "Enter city name"
        cityField.borderStyle = .roundedRect
        cityField.font = .systemFont(ofSize: 16)
        
        // Button
        getButton.setTitle("Get Weather", for: .normal)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.addTarget(self, action: #selector(getTapped), for: .touchUpInside)
        
        // Spinner
        spinner.hidesWhenStopped = true
        
        // Stack
        let stack = UIStackView(arrangedSubviews: [cityField, getButton, spinner])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: Binding
    private func bindVM() {
        vm.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            }
            .store(in: &cancellables)
        
        vm.$forecast
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                let detail = WeatherDetailViewController()
                detail.forecast = model
                self?.navigationController?.pushViewController(detail, animated: true)
            }
            .store(in: &cancellables)
        
        vm.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] msg in
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Prefill favourite
    private func prefillFavourite() {
        if let fav = vm.favouriteCity {
            cityField.text = fav.city
        }
    }
    
    // MARK: Action
    @objc private func getTapped() {
        guard let city = cityField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !city.isEmpty else {
            showAlert(message: "Enter a city")
            return
        }
        vm.fetchForecast(for: city)
    }
    
    private func showAlert(message: String) {
        let a = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}
