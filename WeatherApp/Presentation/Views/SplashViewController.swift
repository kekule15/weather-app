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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.performSegue(withIdentifier: "goToHome", sender: nil)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let homeVC = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                    ) as? HomeViewController else { return }

                    let nav = UINavigationController(rootViewController: homeVC)
                    nav.modalPresentationStyle = .fullScreen

                    //
                    if let windowScene = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first(where: { $0.activationState == .foregroundActive }),
                       let window = windowScene.windows.first {
                        window.rootViewController = nav
                        window.makeKeyAndVisible()
                    }
                }


    }
}

