//
//  ResultCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit


func creatResultListCard(resultCard: UIView, title: UILabel, label: inout [UILabel], result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView, typeOfAnalysis: typeOfAnalysis, materialType: materialType) {
    
    var elasticConstants = 0
    var thermalConstants = 0
    label = []
    result = []
    
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 20).isActive = true
    resultCard.widthAnchor.constraint(equalTo: under.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    switch materialType {
    case .isotropic:
        elasticConstants = 2
        thermalConstants = 1
    case .transverselyIsotropic:
        elasticConstants = 5
        thermalConstants = 2
    case .inPlateMonoclinic:
        elasticConstants = 6
        thermalConstants = 0
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
        result.append(UILabel())
        
        resultCard.addSubview(label[i])
        resultCard.addSubview(result[i])
        
        label[i].resultCardLabelLeftDesign()
        result[i].resultCardLabelRightDesign()
        
        
        switch materialType {
        case .isotropic:
            label[i].text = materialPropertyLabel.isotropic[i]
            result[i].text = ""
        case .transverselyIsotropic:
            label[i].text = materialPropertyLabel.transverselyIsotropic[i]
            result[i].text = ""
        case .inPlateMonoclinic:
            label[i].text = materialPropertyLabel.inPlateMonoclinic[i]
            result[i].text = ""
        case .orthotropic:
            label[i].text = materialPropertyLabel.orthotropic[i]
            result[i].text = ""
        case .monoclinic:
            label[i].text = materialPropertyLabel.monoclinic[i]
            result[i].text = ""
        case .anisotropic:
            label[i].text = materialPropertyLabel.anisotropic[i]
            result[i].text = ""
        }
        
        
        label[i].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
        result[i].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
        
        label[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.6, constant: -16).isActive = true
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.4, constant: -16).isActive = true
        
        label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        if i == 0 {
            label[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
        }
        result[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
        
        if (typeOfAnalysis == .elastic) && (i == elasticConstants-1) {
            label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
        if (materialType == .inPlateMonoclinic) && (i == elasticConstants-1) {
            label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
    }
    
    // Addtional row
    
    if (typeOfAnalysis == .thermalElatic) && (materialType != .inPlateMonoclinic) {
        
        for i in elasticConstants...elasticConstants + thermalConstants - 1 {
            
            label.append(UILabel())
            result.append(UILabel())
            
            resultCard.addSubview(label[i])
            resultCard.addSubview(result[i])
            
            label[i].resultCardLabelLeftDesign()
            result[i].resultCardLabelRightDesign()
            
            
            switch materialType {
            case .isotropic:
                label[i].text = materialPropertyLabel.isotropicThermal[i - elasticConstants]
                result[i].text = ""
            case .transverselyIsotropic:
                label[i].text = materialPropertyLabel.transverselyIsotropicThermal[i - elasticConstants]
                result[i].text = ""
            case .inPlateMonoclinic:
                break
            case .orthotropic:
                label[i].text = materialPropertyLabel.orthotropicThermal[i - elasticConstants]
                result[i].text = ""
            case .monoclinic:
                label[i].text = materialPropertyLabel.monoclinicThermal[i - elasticConstants]
                result[i].text = ""
            case .anisotropic:
                label[i].text = materialPropertyLabel.anisotropicThermal[i - elasticConstants]
                result[i].text = ""
            }
            
            
            label[i].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
            result[i].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
            
            label[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.6, constant: -16).isActive = true
            result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.4, constant: -16).isActive = true
            
            label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            result[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
            result[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
            
            if i == elasticConstants + thermalConstants-1 {
                label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
            }
        }
    }
    
}



func createResult3by3MatrixCard(resultCard: UIView, title: UILabel, result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 20).isActive = true
    resultCard.widthAnchor.constraint(equalTo: under.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    
    for i in 0...8 {
        result.append(UILabel())
        resultCard.addSubview(result[i])
        result[i].resultCardLabelRightDesign()
        result[i].textAlignment = .center
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.3).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    result[0].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
    result[0].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
    
    result[1].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 8).isActive = true
    result[1].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
    
    result[2].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
    result[2].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
    
    
    result[3].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
    result[3].topAnchor.constraint(equalTo: result[1].bottomAnchor, constant: 8).isActive = true
    
    result[4].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 8).isActive = true
    result[4].topAnchor.constraint(equalTo: result[1].bottomAnchor, constant: 8).isActive = true
    
    result[5].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
    result[5].topAnchor.constraint(equalTo: result[1].bottomAnchor, constant: 8).isActive = true
    
    
    result[6].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
    result[6].topAnchor.constraint(equalTo: result[4].bottomAnchor, constant: 8).isActive = true
    result[6].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
    
    result[7].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 8).isActive = true
    result[7].topAnchor.constraint(equalTo: result[4].bottomAnchor, constant: 8).isActive = true
    
    result[8].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
    result[8].topAnchor.constraint(equalTo: result[4].bottomAnchor, constant: 8).isActive = true
}




extension UIView {
    
    func resultCardViewDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 166/255, green: 197/255, blue: 172/255, alpha: 1.0).cgColor
    }
    
}


extension UILabel {
    
    func resultCardTitleDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 118/255, green: 184/255, blue: 130/255, alpha: 1.0)
        self.font = UIFont.boldSystemFont(ofSize: 17)
        self.textColor = .white
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    func resultCardLabelLeftDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor(red: 134/255, green: 140/255, blue: 146/255, alpha: 1.0)
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .right
        self.adjustsFontSizeToFitWidth = true
    }
    
    func resultCardLabelRightDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .left
        self.adjustsFontSizeToFitWidth = true
    }
}
