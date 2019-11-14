//
//  ViewCardDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/2/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

func createSubviewCardWithDividerTitleHelpButton(viewCard: UIView, title: String, helpButton: inout UIButton, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 12).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 0).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: 0).isActive = true
    
    let dividerView = UIView()
    viewCard.addSubview(dividerView)
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    dividerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    dividerView.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    dividerView.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor).isActive = true
    dividerView.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    dividerView.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: -12).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textColor = .greyFontColor
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    viewCard.addSubview(helpButton)
    helpButton.questionButtonDesign(under: viewCard)
    
}

func createSubviewCardWithDividerTitleHelpButtonMethodButton(viewCard: UIView, title: String, helpButton: inout UIButton, methodButton: inout UIButton, isSingleMethodButton: Bool, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 12).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 0).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: 0).isActive = true
    
    let dividerView = UIView()
    viewCard.addSubview(dividerView)
    dividerView.translatesAutoresizingMaskIntoConstraints = false
    dividerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    dividerView.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    dividerView.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor).isActive = true
    dividerView.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    dividerView.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: -12).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textColor = .greyFontColor
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    viewCard.addSubview(helpButton)
    helpButton.questionButtonDesign(under: viewCard)
    
    viewCard.addSubview(methodButton)
    methodButton.methodButtonDesign(under: viewCard)
    
    if isSingleMethodButton {
        methodButton.bottomAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: -12).isActive = true
    }
}


func createViewCardWithTitleHelpButton(viewCard: UIView, title: String, helpButton: inout UIButton, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 12).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -24).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel.textColor = .greyFont2Color
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    viewCard.addSubview(helpButton)
    helpButton.questionButtonDesign(under: viewCard)
    
}



func createViewCardWithTitleHelpButtonMethodButton(viewCard: UIView, title: String, helpButton: inout UIButton, methodButton: inout UIButton, isSingleMethodButton: Bool, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 12).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -24).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel.textColor = .greyFont2Color
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    viewCard.addSubview(helpButton)
    helpButton.questionButtonDesign(under: viewCard)

    viewCard.addSubview(methodButton)
    methodButton.methodButtonDesign(under: viewCard)
    
    if isSingleMethodButton {
        methodButton.bottomAnchor.constraint(equalTo: viewCard.bottomAnchor, constant: -12).isActive = true
    }
}


func createViewCardWithTitleHelpButtonDatabaseButton(viewCard: UIView, title: String, helpButton: inout UIButton, databaseButton: inout UIButton, saveDatabaseButton: inout UIButton, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 12).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -24).isActive = true
    
    let titleLabel = UILabel()
    viewCard.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel.textColor = .greyFont2Color
    titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
    titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
    titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    
    viewCard.addSubview(helpButton)
    helpButton.questionButtonDesign(under: viewCard)
    
    viewCard.addSubview(databaseButton)
    databaseButton.dataBaseButtonDesign(under: viewCard)
    
    viewCard.addSubview(saveDatabaseButton)
    saveDatabaseButton.saveButtonDesign(under: viewCard)
    
}


func createViewCard(viewCard: UIView, title: String? = nil,aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 12).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -24).isActive = true
    
    if let title = title {
        let titleLabel = UILabel()
        viewCard.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .greyFont2Color
        titleLabel.topAnchor.constraint(equalTo: viewCard.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: viewCard.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: viewCard.rightAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }

}


func createViewCardWithoutTitle(viewCard: UIView, aboveConstraint: NSLayoutAnchor<NSLayoutYAxisAnchor>, under: UIView) {
    
    viewCard.layer.cornerRadius = 10
    viewCard.backgroundColor = .whiteThemeColor
    
    viewCard.translatesAutoresizingMaskIntoConstraints = false
    viewCard.topAnchor.constraint(equalTo: aboveConstraint, constant: 8).isActive = true
    viewCard.leftAnchor.constraint(equalTo: under.leftAnchor, constant: 12).isActive = true
    viewCard.widthAnchor.constraint(equalTo: under.widthAnchor, constant: -24).isActive = true
    
}
