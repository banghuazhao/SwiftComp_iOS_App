//
//  MaterialCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit


func createMaterialCard(materialCard: inout UIView, materialName: UILabel, label: inout [UILabel], value: inout [UITextField], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView, typeOfAnalysis: TypeOfAnalysis, materialType: MaterialType) {
    
    var elasticConstants = 0
    var thermalConstants = 0
    label = []
    value = []
    
    materialCard.removeFromSuperview()
    
    materialCard = UIView()
    
    under.addSubview(materialCard)
    
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
    
    switch materialType {
    case .isotropic:
        elasticConstants = 2
        thermalConstants = 1
    case .transverselyIsotropic:
        elasticConstants = 5
        thermalConstants = 2
    case .orthotropic:
        elasticConstants = 9
        thermalConstants = 3
    case .monoclinic:
        elasticConstants = 13
        thermalConstants = 4
    case .anisotropic:
        elasticConstants = 21
        thermalConstants = 6
    }
    
    
    // first to last row for elastic constants
    
    for i in 0...elasticConstants-1 {
        
        label.append(UILabel())
        value.append(UITextField())
        
        materialCard.addSubview(label[i])
        materialCard.addSubview(value[i])
        
        switch materialType {
        case .isotropic:
            label[i].text = materialPropertyLabel.isotropic[i]
            value[i].placeholder = materialPropertyPlaceHolder.isotropic[i]
        case .transverselyIsotropic:
            label[i].text = materialPropertyLabel.transverselyIsotropic[i]
            value[i].placeholder = materialPropertyPlaceHolder.transverselyIsotropic[i]
        case .orthotropic:
            label[i].text = materialPropertyLabel.orthotropic[i]
            value[i].placeholder = materialPropertyPlaceHolder.orthotropic[i]
        case .monoclinic:
            label[i].text = materialPropertyLabel.monoclinic[i]
            value[i].placeholder = materialPropertyPlaceHolder.monoclinic[i]
        case .anisotropic:
            label[i].text = materialPropertyLabel.anisotropic[i]
            value[i].placeholder = materialPropertyPlaceHolder.anisotropic[i]
        }
        
        label[i].materialCardLabelDesign()
        value[i].materialCardTextFieldDesign()
        value[i].keyboardType = UIKeyboardType.numbersAndPunctuation
        
        label[i].leftAnchor.constraint(equalTo: materialCard.leftAnchor, constant: 8).isActive = true
        value[i].rightAnchor.constraint(equalTo: materialCard.rightAnchor, constant: -8).isActive = true
        
        label[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
        value[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
        
        label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        value[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        if i == 0 {
            label[i].topAnchor.constraint(equalTo: materialName.bottomAnchor, constant: 8).isActive = true
        } else {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 6).isActive = true
        }
        value[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
        
        if typeOfAnalysis == .elastic &&  i == elasticConstants-1 {
            label[i].bottomAnchor.constraint(equalTo: materialCard.bottomAnchor, constant: -8).isActive = true
        }
        
    }
    
    // Addtional row
    
    if typeOfAnalysis == .thermoElastic {
    
        for i in elasticConstants...elasticConstants + thermalConstants-1 {
            
            label.append(UILabel())
            value.append(UITextField())
            
            materialCard.addSubview(label[i])
            materialCard.addSubview(value[i])
            
            switch materialType {
            case .isotropic:
                label[i].text = materialPropertyLabel.isotropicThermal[i - elasticConstants]
                value[i].placeholder = materialPropertyPlaceHolder.isotropicThermal[i - elasticConstants]
            case .transverselyIsotropic:
                label[i].text = materialPropertyLabel.transverselyIsotropicThermal[i - elasticConstants]
                value[i].placeholder = materialPropertyPlaceHolder.transverselyIsotropicThermal[i - elasticConstants]
            case .orthotropic:
                label[i].text = materialPropertyLabel.orthotropicThermal[i - elasticConstants]
                value[i].placeholder = materialPropertyPlaceHolder.orthotropicThermal[i - elasticConstants]
            case .monoclinic:
                label[i].text = materialPropertyLabel.monoclinicThermal[i - elasticConstants]
                value[i].placeholder = materialPropertyPlaceHolder.monoclinicThermal[i - elasticConstants]
            case .anisotropic:
                label[i].text = materialPropertyLabel.anisotropicThermal[i - elasticConstants]
                value[i].placeholder = materialPropertyPlaceHolder.anisotropicThermal[i - elasticConstants]
            }
            
            label[i].materialCardLabelDesign()
            value[i].materialCardTextFieldDesign()
            value[i].keyboardType = UIKeyboardType.numbersAndPunctuation
            
            label[i].leftAnchor.constraint(equalTo: materialCard.leftAnchor, constant: 8).isActive = true
            value[i].rightAnchor.constraint(equalTo: materialCard.rightAnchor, constant: -8).isActive = true
            
            label[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            value[i].widthAnchor.constraint(equalTo: materialCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            
            label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            value[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 6).isActive = true
            value[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
            
            if i == elasticConstants + thermalConstants-1 {
                label[i].bottomAnchor.constraint(equalTo: materialCard.bottomAnchor, constant: -8).isActive = true
            }
        }
    }

}


extension UIView {
    
    func materialCardViewDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .materialCardColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.materialCardBorderColor.cgColor
    }
    
}


extension UITextField {
    
    func materialCardTextFieldDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.whitebackgroundColor
        self.borderStyle = .roundedRect
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .left
        self.adjustsFontSizeToFitWidth = true
    }
    
}

extension UILabel {
    
    func materialCardTitleDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .materialCardColor
        self.textColor = .greyFontColor
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    func materialCardLabelDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .materialCardColor
        self.textColor = .greyFontColor
        self.font = UIFont.systemFont(ofSize: 14)
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .right
    }
    
}
