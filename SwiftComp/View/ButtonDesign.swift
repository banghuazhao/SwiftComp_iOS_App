//
//  ButtonDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIButton {
    
    func methodButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(self.tintColor, for: .normal)
        self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: self.intrinsicContentSize.width + 40).isActive = true
    }
    
    func dataBaseButtonDesign(title: String, under: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle(title, for: UIControl.State.normal)
        self.setTitleColor(self.tintColor, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 240/255, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: -59.5).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
    }
    
    func saveButtonDesign(title: String, under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: UIControl.State.normal)
        self.setTitleColor(self.tintColor, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 59.5).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    
    
    func calculateButtonDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 129/255, green: 197/255, blue: 72/255, alpha: 1.0)
        self.setTitle("Calculate", for: UIControl.State.normal)
        self.tintColor = .white
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.frame = CGRect(x: 0, y: 0, width: self.intrinsicContentSize.width + 30, height: 30)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
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
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        layer.add(flash, forKey: nil)
    }
}

