//
//  ViewCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/2/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit


func creatViewCard(viewCard: UIView, title: String, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    under.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 6).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 10).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -20).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

}
