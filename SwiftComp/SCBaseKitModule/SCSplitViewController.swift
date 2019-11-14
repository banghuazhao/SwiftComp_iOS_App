//
//  SCSplitViewController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/11/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SCSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        preferredDisplayMode = .allVisible
        
    }
}
