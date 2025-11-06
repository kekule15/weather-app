//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import UIKit

class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }
}

