//
//  customTabBarController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/2/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .navBarColor
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .greenThemeColor
        self.tabBar.unselectedItemTintColor = .white
        
        let compositeModelsController = CompositeModelsViewController()
        compositeModelsController.tabBarItem.title = "Models"
        compositeModelsController.tabBarItem.image = UIImage.fontAwesomeIcon(name: .thList, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        let generalViewController = GeneralViewController()
        generalViewController.tabBarItem.title = "General"
        generalViewController.tabBarItem.image = UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
            
        self.setViewControllers([compositeModelsController, generalViewController], animated: true)
        
    }
}
