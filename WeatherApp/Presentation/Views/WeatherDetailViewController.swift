//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var weather: WeatherResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let weather = weather {
            cityLabel.text = weather.name
            tempLabel.text = String(format: "%.1f °C", weather.main.temp)
            descriptionLabel.text = weather.weather.first?.description.capitalized
        }
    }
}
