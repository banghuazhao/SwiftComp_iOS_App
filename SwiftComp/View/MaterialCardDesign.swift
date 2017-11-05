//
//  MaterialCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit


func createMaterialCard(materialCard: UIView, materialName: UILabel, label: [UILabel], value: [UITextField], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    materialCard.materialCardViewDesign()
    materialCard.widthAnchor.constraint(equalTo: under.widthAnchor, multiplier: 0.8).isActive = true
    materialCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    materialCard.centerXAnchor.constraint(equalTo: under.centerXAnchor).isActive = true
    materialCard.addSubview(materialName)
    
    materialName.materialCardTitleDesign()
    materialName.topAnchor.constraint(equalTo: materialCard.topAnchor, constant: 8).isActive = true
    materialName.leftAnchor.constraint(equalTo: materialCard.leftAnchor, constant: 8).isActive = true
    materialName.rightAnchor.constraint(equalTo: materialCard.rightAnchor, constant: -8).isActive = true
    materialName.heightAnchor.constraint(equalToConstant: 25).isActive = true
    
    for i in 0...label.count-1 {
        materialCard.addSubview(label[i])
        label[i].materialCardLabelDesign()
        
        label[i].leftAnchor.constraint(equalTo: materialCard.leftAnchor, constant: 8).isActive = true
        label[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
        label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        if i == 0 {
            label[i].topAnchor.constraint(equalTo: materialName.bottomAnchor, constant: 8).isActive = true
        }
        else if i == label.count-1 {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
            label[i].bottomAnchor.constraint(equalTo: materialCard.bottomAnchor, constant: -8).isActive = true
        }
        else {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
        }
    }
    
    for i in 0...label.count-1 {
        materialCard.addSubview(value[i])
        value[i].materialCardTextFieldDesign()
        
        value[i].rightAnchor.constraint(equalTo: materialCard.rightAnchor, constant: -8).isActive = true
        value[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
        value[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        value[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
    }
    
}



extension UIView {
    
    func materialCardViewDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 223/255, green: 220/255, blue: 194/255, alpha: 1.0).cgColor
    }
    
}


extension UITextField {
    
    func materialCardTextFieldDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.borderStyle = .roundedRect
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .left
        self.adjustsFontSizeToFitWidth = true
    }
    
}

extension UILabel {
    
    func materialCardTitleDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        self.textColor = UIColor(red: 130/255, green: 138/255, blue: 145/255, alpha: 1.0)
        self.font = UIFont.boldSystemFont(ofSize: 17)
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    func materialCardLabelDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        self.textColor = UIColor(red: 130/255, green: 138/255, blue: 145/255, alpha: 1.0)
        self.font = UIFont.systemFont(ofSize: 14)
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .right
    }
    
}
