//
//  HomeHelp.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/22/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteThemeColor
        
        self.navigationItem.title = "About"
        
        editLayout()
        
        
    }
    
    
    deinit {
        print("About viewContorller is deinitialized")
    }
    
    
    func editLayout() {
        
        let scrollView: UIScrollView = UIScrollView()
        
        self.view.addSubview(scrollView)
        
        scrollView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        
        let brandTitle: UITextView = UITextView()
        
        let swiftcompTitle: UITextView = UITextView()
        let swiftcompModel: UITextView = UITextView()
        
        let swiftcompAppTitle: UITextView = UITextView()
        let swiftcompApp: UITextView = UITextView()
        
        let privacyTitle: UITextView = UITextView()
        let privacy: UITextView = UITextView()
        
        scrollView.addSubview(brandTitle)
        scrollView.addSubview(swiftcompTitle)
        scrollView.addSubview(swiftcompModel)
        scrollView.addSubview(swiftcompAppTitle)
        scrollView.addSubview(swiftcompApp)
        scrollView.addSubview(privacyTitle)
        scrollView.addSubview(privacy)
        
        
        brandTitle.translatesAutoresizingMaskIntoConstraints = false
        brandTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        brandTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        brandTitle.text = "About"
        brandTitle.font = UIFont.boldSystemFont(ofSize: 20)
        brandTitle.isScrollEnabled = false
        brandTitle.isEditable = false
        brandTitle.backgroundColor = .whiteThemeColor
        brandTitle.textColor = .blackThemeColor
        
        swiftcompTitle.translatesAutoresizingMaskIntoConstraints = false
        swiftcompTitle.topAnchor.constraint(equalTo: brandTitle.bottomAnchor, constant: 24).isActive = true
        swiftcompTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        swiftcompTitle.text = "SwiftComp"
        swiftcompTitle.font = UIFont.boldSystemFont(ofSize: 15)
        swiftcompTitle.isScrollEnabled = false
        swiftcompTitle.isEditable = false
        swiftcompTitle.backgroundColor = .whiteThemeColor
        swiftcompTitle.textColor = .blackThemeColor
        
        let swiftcompTitleAttributedString = NSMutableAttributedString(string: """
        SwiftComp represents a general-purpose computational approach for constitutive modeling of composite materials and structures. It is develped by professor Wenbin Yu and coworkers at Purdue university. It unifies modeling of composites beam, plates/shells, or 3D structures. It can quickly and easily calculate all the effective properties for a wide variety of composites, computing the best structural model for use in macroscopic structural analysis, as well as dehomogenization..
        
        SwiftComp is commercialized by AnalySwift. For more information, visit https://analyswift.com/.
        """)
        swiftcompTitleAttributedString.setAttributes(
            [.link: URL(string: "https://engineering.purdue.edu/AAE/people/ptProfile?resource_id=93761")!],
            range: swiftcompTitleAttributedString.mutableString.range(of: "Wenbin Yu"))
        swiftcompTitleAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blackThemeColor, NSAttributedString.Key.backgroundColor : UIColor.whiteThemeColor], range: NSRange(location: 0, length: swiftcompTitleAttributedString.length))
        
        swiftcompModel.translatesAutoresizingMaskIntoConstraints = false
        swiftcompModel.topAnchor.constraint(equalTo: swiftcompTitle.bottomAnchor, constant: 6).isActive = true
        swiftcompModel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        swiftcompModel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        swiftcompModel.attributedText = swiftcompTitleAttributedString
        swiftcompModel.font = UIFont.systemFont(ofSize: 14)
        swiftcompModel.isScrollEnabled = false
        swiftcompModel.isEditable = false
        swiftcompModel.textAlignment = .justified
        swiftcompModel.dataDetectorTypes = UIDataDetectorTypes.all
        swiftcompModel.backgroundColor = .whiteThemeColor
        
        swiftcompAppTitle.translatesAutoresizingMaskIntoConstraints = false
        swiftcompAppTitle.topAnchor.constraint(equalTo: swiftcompModel.bottomAnchor, constant: 12).isActive = true
        swiftcompAppTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        swiftcompAppTitle.text = "SwiftComp iOS App"
        swiftcompAppTitle.font = UIFont.boldSystemFont(ofSize: 15)
        swiftcompAppTitle.isScrollEnabled = false
        swiftcompAppTitle.isEditable = false
        swiftcompAppTitle.backgroundColor = .whiteThemeColor
        swiftcompAppTitle.textColor = .blackThemeColor
        
        let swiftcompAppAttributedString = NSMutableAttributedString(string: """
        To facilitate the use of SwiftComp, this iOS App is develped by Banghua Zhao.
        
        The current functionalities are:
        1. Calculate effective beam stiffness matrix for beam model.
        2. Calculate A, B, D matrices, transverse shear stiffness matrix, in-plane properties, and flexural properties for plate model.
        3. Calculate effective solid stiffness matrix and engineering constants for solid model.
        4. Calculate coefficient of thermal expansions (CTEs) for the thermoelastic analysis.
        5. Use Gmsh as mesh generator to generate mesh and image.
        
        The current composites models are:
        1. Laminate
        2. Unidirectional fiber reinforced composite
        3. Honeycomb Sandwich Structure
        
        We are constantly adding more functionalities into this app.
        
        Note, the functionalities of the App are very limited in comparison to full version of SwiftComp.
        """)
        swiftcompAppAttributedString.setAttributes([.link: URL(string: "http://www.banghuazhao.com/")!], range: swiftcompAppAttributedString.mutableString.range(of: "Banghua Zhao"))
        swiftcompAppAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blackThemeColor, NSAttributedString.Key.backgroundColor : UIColor.whiteThemeColor], range: NSRange(location: 0, length: swiftcompAppAttributedString.length))
        
        swiftcompApp.translatesAutoresizingMaskIntoConstraints = false
        swiftcompApp.topAnchor.constraint(equalTo: swiftcompAppTitle.bottomAnchor, constant: 6).isActive = true
        swiftcompApp.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        swiftcompApp.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        swiftcompApp.attributedText = swiftcompAppAttributedString
        swiftcompApp.font = UIFont.systemFont(ofSize: 14)
        swiftcompApp.isScrollEnabled = false
        swiftcompApp.isEditable = false
        swiftcompApp.textAlignment = .justified
        swiftcompApp.backgroundColor = .whiteThemeColor
        
        
        let cdmHUBTitle: UITextView = UITextView()
        let cdmHUBText: UITextView = UITextView()
        
        scrollView.addSubview(cdmHUBTitle)
        scrollView.addSubview(cdmHUBText)
        
        cdmHUBTitle.translatesAutoresizingMaskIntoConstraints = false
        cdmHUBTitle.topAnchor.constraint(equalTo: swiftcompApp.bottomAnchor, constant: 12).isActive = true
        cdmHUBTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        cdmHUBTitle.text = "cdmHUB"
        cdmHUBTitle.font = UIFont.boldSystemFont(ofSize: 15)
        cdmHUBTitle.isScrollEnabled = false
        cdmHUBTitle.isEditable = false
        cdmHUBTitle.backgroundColor = .whiteThemeColor
        cdmHUBTitle.textColor = .blackThemeColor
        
        let cdmHUBTAttributedString = NSMutableAttributedString(string: """
        If you want to use more functionalities of SwiftComp, you can find the web version of SwiftComp is at cdmHUB.

        Please note that only registered users at cdmHUB can run the web version of SwiftComp.
        """)
        cdmHUBTAttributedString.setAttributes([.link: URL(string: "https://cdmhub.org/resources/scstandard")!], range: cdmHUBTAttributedString.mutableString.range(of: "cdmHUB"))
        cdmHUBTAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blackThemeColor, NSAttributedString.Key.backgroundColor : UIColor.whiteThemeColor], range: NSRange(location: 0, length: cdmHUBTAttributedString.length))
        
        cdmHUBText.translatesAutoresizingMaskIntoConstraints = false
        cdmHUBText.topAnchor.constraint(equalTo: cdmHUBTitle.bottomAnchor, constant: 6).isActive = true
        cdmHUBText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        cdmHUBText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        cdmHUBText.attributedText = cdmHUBTAttributedString
        cdmHUBText.font = UIFont.systemFont(ofSize: 14)
        cdmHUBText.isScrollEnabled = false
        cdmHUBText.isEditable = false
        cdmHUBText.textAlignment = .justified
        cdmHUBText.backgroundColor = .whiteThemeColor
        
        privacyTitle.translatesAutoresizingMaskIntoConstraints = false
        privacyTitle.topAnchor.constraint(equalTo: cdmHUBText.bottomAnchor, constant: 12).isActive = true
        privacyTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        privacyTitle.text = "Privacy"
        privacyTitle.font = UIFont.boldSystemFont(ofSize: 15)
        privacyTitle.isScrollEnabled = false
        privacyTitle.isEditable = false
        privacyTitle.backgroundColor = .whiteThemeColor
        privacyTitle.textColor = .blackThemeColor
        
        privacy.translatesAutoresizingMaskIntoConstraints = false
        privacy.topAnchor.constraint(equalTo: privacyTitle.bottomAnchor, constant: 6).isActive = true
        privacy.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
        privacy.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        privacy.text = """
        For privacy, visit https://cdmhub.org/legal/terms.
        """
        privacy.isScrollEnabled = false
        privacy.isEditable = false;
        privacy.dataDetectorTypes = UIDataDetectorTypes.all;
        privacy.font = UIFont.systemFont(ofSize: 14)
        privacy.isScrollEnabled = false
        privacy.isEditable = false
        privacy.backgroundColor = .whiteThemeColor
        privacy.textColor = .blackThemeColor
        
        privacy.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        
    }
    
    
}
