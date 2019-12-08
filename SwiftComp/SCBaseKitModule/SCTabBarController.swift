//
//  customTabBarController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/2/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class SCTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = .SCNavigation
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .SCGreen
        self.tabBar.unselectedItemTintColor = .white
        
        let compositeModelsController = CompositeModelController()
        compositeModelsController.tabBarItem.title = "Models"
        compositeModelsController.tabBarItem.image = UIImage(named: "model_list_white")
        compositeModelsController.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let generalController = GeneralController()
        generalController.tabBarItem.title = "General"
        generalController.tabBarItem.image = UIImage(named: "general_white")
        generalController.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            
        self.setViewControllers([compositeModelsController, generalController], animated: true)
        
    }
}
