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
    
    var scrollView: UIScrollView = UIScrollView()
    
    var swiftCompCalculationInfoTextView: UITextView = UITextView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteThemeColor
        
        navigationItem.title = "SwiftComp Calculation Info"
        
        editLayout()
        
    }
    
    
    
    func editLayout() {
        
        let shareButtonImage = UIImage.fontAwesomeIcon(name: .shareSquare, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: shareButtonImage, style: .plain, target: self, action: #selector(shareCalculationInfo))
        
        
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
    
    @objc func shareCalculationInfo() {
         
        let file = getDocumentsDirectory().appendingPathComponent("SwiftComp_calculation_info.txt")

        do {
            try swiftCompCalculationInfoValue.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view

        self.present(activityVC, animated: true, completion: nil)
    }
}
