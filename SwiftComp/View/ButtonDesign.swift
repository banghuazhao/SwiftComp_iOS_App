//
//  ButtonDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIButton {
    
    func dataBaseButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(self.tintColor, for: .normal)
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 240/255, alpha: 1.0)
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2
        self.titleLabel?.textAlignment = .center
        
    }
    
    func calculateButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 129/255, green: 197/255, blue: 72/255, alpha: 1.0)
        self.setTitle("Calculate", for: UIControlState.normal)
        self.tintColor = .white
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.frame = CGRect(x: 0, y: 0, width: self.intrinsicContentSize.width + 30, height: 30)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 34/255, green: 128/255, blue: 43/255, alpha: 1.0).cgColor
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        
        flash.duration = 0.2
        flash.fromValue = 0.6
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.add(flash, forKey: nil)
    }
}

