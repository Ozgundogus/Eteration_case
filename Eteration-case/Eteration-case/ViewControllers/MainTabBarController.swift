//
//  MainTabBarController.swift
//  Eteration-case
//
//  Created by Ozgun Dogus on 7.01.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let homeViewController = ProductListViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let cartViewController = CartViewController()
        cartViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))

        viewControllers = [homeViewController, cartViewController].map {
            UINavigationController(rootViewController: $0)
        }
    }
}
