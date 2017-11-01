//
//  ResultCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit



func creatResultListCard(resultCard: UIView, title: UILabel, label: [UILabel], result: [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
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
    
    for i in 0...label.count-1 {
        resultCard.addSubview(label[i])
        label[i].resultCardLabelLeftDesign()
        
        label[i].leftAnchor.constraint(equalTo: resultCard.leftAnchor, constant: 8).isActive = true
        label[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
        label[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        if i == 0 {
            label[i].topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        }
        else if i == label.count-1{
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
            label[i].bottomAnchor.constraint(equalTo: resultCard.bottomAnchor, constant: -8).isActive = true
        }
        else {
            label[i].topAnchor.constraint(equalTo: label[i-1].bottomAnchor, constant: 8).isActive = true
        }
    }
    
    for i in 0...label.count-1 {
        resultCard.addSubview(result[i])
        result[i].resultCardLabelRightDesign()
        
        result[i].rightAnchor.constraint(equalTo: resultCard.rightAnchor, constant: -8).isActive = true
        result[i].widthAnchor.constraint(equalTo: resultCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
        result[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
        result[i].centerYAnchor.constraint(equalTo: label[i].centerYAnchor, constant: 0).isActive = true
    }
    
}



func createResult3by3MatrixCard(resultCard: UIView, title: UILabel, result: [UILabel], aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
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
