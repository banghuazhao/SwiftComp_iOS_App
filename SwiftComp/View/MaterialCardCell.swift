//
//  MaterialCardCell.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/27/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class MaterialCardCell1: UITableViewCell {
    
    let materialpropertyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.cardViewDesignForLabel()
        return label
    }()
    
    let materialpropertyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.cardViewDesignForTextField()
        return textField
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        
        addSubview(materialpropertyLabel)
        materialpropertyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        materialpropertyLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        materialpropertyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        materialpropertyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -16).isActive = true
        
        addSubview(materialpropertyTextField)
        materialpropertyTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        materialpropertyTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        materialpropertyTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        materialpropertyTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
