//
//  SwiftCompCalculationInfo.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SwiftCompCalculationInfo: UIViewController {
    
    var swiftCompCalculationInfoValue : String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .whitebackgroundColor
        
        self.navigationController?.title = "SwiftComp Calculation Info"
        
        editLayout()
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    var scrollView: UIScrollView = UIScrollView()
    
    var swiftCompCalculationInfoTextView: UITextView = UITextView()
    
    
    func editLayout() {
        
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(swiftCompCalculationInfoTextView)
        
        swiftCompCalculationInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        swiftCompCalculationInfoTextView.text = swiftCompCalculationInfoValue
        swiftCompCalculationInfoTextView.isScrollEnabled = false
        swiftCompCalculationInfoTextView.isEditable = false
        swiftCompCalculationInfoTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        swiftCompCalculationInfoTextView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
        swiftCompCalculationInfoTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16).isActive = true
        swiftCompCalculationInfoTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        

        swiftCompCalculationInfoTextView.font = UIFont.systemFont(ofSize: 12)
        
    }
}
