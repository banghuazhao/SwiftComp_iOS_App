//
//  ResultCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

let resultLabel = ResultCardLabel()

func creatResultListCard(resultCard: UIView, title: UILabel, label: inout [UILabel], result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView, resultType: ResultCardType) {
    
    var items = 0

    label = []
    result = []
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 16).isActive = true
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    if resultType == .engineeringConstantsOrthotropic {
        items = 9
    } else if resultType == .inPlateProperties {
        items = 6
    } else if resultType == .thermalCoefficients {
        items = 6
    }
    
    let unitWitdth = cardWidth * 0.01
    
    for i in 0...items-1 {
        
        label.append(UILabel())
        result.append(UILabel())
        
        resultCard.addSubview(label[i])
        resultCard.addSubview(result[i])
        
        label[i].resultCardLabelLeftRightAlignDesign()
        result[i].resultCardLabelRightLeftAlignDesign()
        
        if resultType == .engineeringConstantsOrthotropic {
            label[i].text = resultLabel.engineeringConstantsOrthotropicLabel[i]
            result[i].text = ""
        } else if resultType == .inPlateProperties {
            label[i].text = resultLabel.inPlatePropertiesLabel[i]
            result[i].text = ""
        } else if resultType == .thermalCoefficients {
            label[i].text = resultLabel.thermalCoefficientsLabel[i]
            result[i].text = ""
        }
        
        label[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -20 * unitWitdth).isActive = true
        result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 30 * unitWitdth).isActive = true
        
        label[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.5).isActive = true
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.3).isActive = true
        
        label[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        if i == 0 {
            label[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
        }
        
        if (i == items-1) {
            label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
        result[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
        
    }
    
}



func createResult3by3MatrixCard(resultCard: UIView, title: UILabel, result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView, firstCard: Bool) {
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    if firstCard {
        resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 40).isActive = true
    } else {
        resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 16).isActive = true
    }
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    let unitWitdth = cardWidth * 0.16
    
    result = []
    
    for i in 0...8 {
        result.append(UILabel())
        resultCard.addSubview(result[i])
        result[i].resultCardLabelCenterAlignDesign()
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.3).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        switch i % 3 {
        case 0:
            // 1st column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -2 * unitWitdth).isActive = true
        case 1:
            // 2nd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 0 * unitWitdth).isActive = true
        case 2:
            // 3rd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 2 * unitWitdth).isActive = true
        default:
            break
        }
        
        if (i < 3) {
            result[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            result[i].topAnchor.constraint(equalTo: result[i-3].bottomAnchor, constant: 8).isActive = true
        }
        
        if (i == 8) {
            result[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
    }
    
}


func createResult4by4MatrixCard(resultCard: UIView, title: UILabel, result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView, firstCard: Bool) {
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    if firstCard {
        resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 40).isActive = true
    } else {
        resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 16).isActive = true
    }
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    let unitWitdth = cardWidth * 0.12
    
    result = []
    
    for i in 0...15 {
        result.append(UILabel())
        resultCard.addSubview(result[i])
        result[i].resultCardLabelCenterAlignDesign()
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.2).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        switch i % 4 {
        case 0:
            // 1st column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -3 * unitWitdth).isActive = true
        case 1:
            // 2nd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -1 * unitWitdth).isActive = true
        case 2:
            // 3rd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 1 * unitWitdth).isActive = true
        case 3:
            // 4rd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 3 * unitWitdth).isActive = true
        default:
            break
        }
        
        if (i < 4) {
            result[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            result[i].topAnchor.constraint(equalTo: result[i-4].bottomAnchor, constant: 8).isActive = true
        }
        
        if (i == 15) {
            result[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
    }
    
}



func createResult6by6MatrixCard(resultCard: UIView, title: UILabel, result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 40).isActive = true
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    let unitWitdth = cardWidth * 0.08
    
    result = []
    
    for i in 0...35 {
        
        result.append(UILabel())
        
        resultCard.addSubview(result[i])
        
        result[i].resultCardLabelCenterAlignDesign()
        result[i].text = ""
        result[i].font = UIFont.systemFont(ofSize: 12)
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.14).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        switch i % 6 {
        case 0:
            // 1st column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -5 * unitWitdth).isActive = true
        case 1:
            // 2nd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -3 * unitWitdth).isActive = true
        case 2:
            // 3rd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -1 * unitWitdth).isActive = true
        case 3:
            // 4th column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 1 * unitWitdth).isActive = true
        case 4:
            // 5th column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 3 * unitWitdth).isActive = true
        case 5:
            // 6th column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 5 * unitWitdth).isActive = true
        default:
            break
        }
        
        if (i < 6) {
            result[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            result[i].topAnchor.constraint(equalTo: result[i-6].bottomAnchor, constant: 8).isActive = true
        }
        
        if (i == 35) {
            result[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
    }
    
}


func createResult6by6MatrixCardTwoColumn(resultCard: UIView, title: UILabel, label: inout [UILabel], result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 40).isActive = true
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    label = []
    result = []
    
    for i in 0...20 {
        
        label.append(UILabel())
        result.append(UILabel())
        
        resultCard.addSubview(result[i])
        resultCard.addSubview(label[i])
        
        label[i].resultCardLabelCenterAlignDesign()
        label[i].text = resultLabel.effectiveSolidStiffnessMatrixLabel[i]
        label[i].widthAnchor.constraint(equalToConstant: 40).isActive = true
        label[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        label[i].textColor = UIColor(red: 134/255, green: 140/255, blue: 146/255, alpha: 1.0)
        
        result[i].resultCardLabelRightLeftAlignDesign()
        result[i].text = ""
        result[i].widthAnchor.constraint(equalToConstant: 60).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        if i % 2 == 0 {
            // first column
            label[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -90).isActive = true
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -35).isActive = true
            
        } else {
            // second column
            label[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 25).isActive = true
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 80).isActive = true
        }
        
        if (i == 0 || i == 1) {
            label[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            label[i].topAnchor.constraint(equalTo: label[i-2].bottomAnchor, constant: 8).isActive = true
        }
        
        
        if (i == 20) {
            label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
        result[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
        
    }
    
}


func createGeneralTwoByTwoStiffnessMatrix(resultCard: UIView, title: UILabel, result: inout [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    let cardWidth =  [UIScreen.main.bounds.width - 48, 320].min() ?? 320
    
    resultCard.resultCardViewDesign()
    resultCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 16).isActive = true
    resultCard.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
    resultCard.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 0).isActive = true
    resultCard.addSubview(title)
    
    title.resultCardTitleDesign()
    title.topAnchor.constraint(equalTo: resultCard.topAnchor, constant: 0).isActive = true
    title.leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 0).isActive = true
    title.rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: 0).isActive = true
    title.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    let unitWitdth = cardWidth * 0.01
    
    result = []
    
    for i in 0...3 {
        
        result.append(UILabel())
        
        resultCard.addSubview(result[i])
        
        result[i].resultCardLabelCenterAlignDesign()
        result[i].text = ""
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.25).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        switch i % 2 {
        case 0:
            // 1st column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: -25 * unitWitdth).isActive = true
        case 1:
            // 2nd column
            result[i].centerXAnchor.constraint(equalTo: resultCard.centerXAnchor, constant: 25 * unitWitdth).isActive = true
        default:
            break
        }
        
        if (i < 2) {
            result[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        } else {
            result[i].topAnchor.constraint(equalTo: result[i-2].bottomAnchor, constant: 8).isActive = true
        }
        
        if (i == 3) {
            result[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        
    }
    
}



extension UIView {
    
    func resultCardViewDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .whiteThemeColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 166/255, green: 197/255, blue: 172/255, alpha: 1.0).cgColor
    }
    
}


extension UILabel {
    
    func resultCardTitleDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 118/255, green: 184/255, blue: 130/255, alpha: 1.0)
        self.font = UIFont.boldSystemFont(ofSize: 15)
        self.textColor = .white
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
    func resultCardLabelLeftRightAlignDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .greyFontColor
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .right
        self.adjustsFontSizeToFitWidth = true
    }
    
    func resultCardLabelRightLeftAlignDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .left
        self.adjustsFontSizeToFitWidth = true
    }
    
    func resultCardLabelCenterAlignDesign() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
    }
    
}
