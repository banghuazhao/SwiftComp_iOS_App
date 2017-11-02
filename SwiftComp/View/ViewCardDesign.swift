//
//  ViewCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/2/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit


func creatViewCard(viewCard: UIView, title: String, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    let titleLabel = UILabel()
    let topDivider = UIView()
    let bottomDivider = UIView()
    
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 0).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 0).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: 0).isActive = true
    viewCard.addSubview(titleLabel)
    viewCard.addSubview(topDivider)
    viewCard.addSubview(bottomDivider)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    topDivider.translatesAutoresizingMaskIntoConstraints = false
    topDivider.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    topDivider.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    topDivider.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 0).isActive = true
    topDivider.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    topDivider.heightAnchor.constraint(equalToConstant: 2) .isActive = true
    
    bottomDivider.translatesAutoresizingMaskIntoConstraints = false
    bottomDivider.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    bottomDivider.topAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: 0).isActive = true
    bottomDivider.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 0).isActive = true
    bottomDivider.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    bottomDivider.heightAnchor.constraint(equalToConstant: 2) .isActive = true

}
