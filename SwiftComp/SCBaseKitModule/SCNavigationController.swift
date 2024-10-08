//
//  SCNavigationController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/11/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SCNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.barTintColor = .navBarColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        toolbar.barTintColor = .navBarColor
        toolbar.isTranslucent = false
        toolbar.tintColor = .greenThemeColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
