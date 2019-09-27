//
//  SwiftCompOutput.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class SwiftCompCalculationInfo: UIViewController {
    
    var swiftCompOutputValue : String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        editLayout()
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    var scrollView: UIScrollView = UIScrollView()
    
    var swiftCompOutputTextView: UITextView = UITextView()
    
    
    func editLayout() {
        
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(swiftCompOutputTextView)
        
        swiftCompOutputTextView.translatesAutoresizingMaskIntoConstraints = false
        swiftCompOutputTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12).isActive = true
        swiftCompOutputTextView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8).isActive = true
        swiftCompOutputTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16).isActive = true
        swiftCompOutputTextView.text = swiftCompOutputValue

        swiftCompOutputTextView.font = UIFont.systemFont(ofSize: 14)
        
    }
}
