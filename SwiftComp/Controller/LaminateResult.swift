//
//  LaminateResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/28/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class LaminateResult: UIViewController {
    
    var effective3DProperties = [Double](repeating: 0, count: 9)
    var effectiveInPlaneProperties = [Double](repeating: 0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0, count: 6)
    
    var scrollView: UIScrollView = UIScrollView()
    
    // First section

    var threeDPropertiesCard: UIView = UIView()
    
    var threeDPropertiesTitleLabel: UILabel = UILabel()
    
    var threeDPropertiesLabel: [UILabel] = []
    
    var threeDPropertiesResultLabel: [UILabel] = []
    
    
    // Second section
    
    var inPlanePropertiesCard: UIView = UIView()
    
    var inPlanePropertiesTitleLabel: UILabel = UILabel()
    
    var inPlanePropertiesLabel: [UILabel] = []
    
    var inPlanePropertiesResultLabel: [UILabel] = []
    
    // Third section
    
    var flexuralPropertiesCard: UIView = UIView()
    
    var flexuralPropertiesTitleLabel: UILabel = UILabel()
    
    var flexuralPropertiesLabel: [UILabel] = []
    
    var flexuralPropertiesResultLabel: [UILabel] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        createLayout()
        
        applyResult()
        
    }
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        scrollView.addSubview(threeDPropertiesCard)
        scrollView.addSubview(inPlanePropertiesCard)
        scrollView.addSubview(flexuralPropertiesCard)
        
        
        // first section
        
        threeDPropertiesCard.resultCardViewDesign()
        threeDPropertiesCard.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        threeDPropertiesCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        threeDPropertiesCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        threeDPropertiesCard.addSubview(threeDPropertiesTitleLabel)
        
        threeDPropertiesTitleLabel.resultCardTitleDesign()
        threeDPropertiesTitleLabel.text = "3D Properties"
        threeDPropertiesTitleLabel.topAnchor.constraint(equalTo: threeDPropertiesCard.topAnchor, constant: 0).isActive = true
        threeDPropertiesTitleLabel.leftAnchor.constraint(equalTo: threeDPropertiesCard.leftAnchor, constant: 0).isActive = true
        threeDPropertiesTitleLabel.rightAnchor.constraint(equalTo: threeDPropertiesCard.rightAnchor, constant: 0).isActive = true
        threeDPropertiesTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for i in 0...8 {
            threeDPropertiesLabel.append(UILabel())
            threeDPropertiesCard.addSubview(threeDPropertiesLabel[i])
            threeDPropertiesLabel[i].resultCardLabelLeftDesign()
            switch i {
            case 0:
                threeDPropertiesLabel[i].text = "Young's Modulus E1"
            case 1:
                threeDPropertiesLabel[i].text = "Young's Modulus E2"
            case 2:
                threeDPropertiesLabel[i].text = "Young's Modulus E3"
            case 3:
                threeDPropertiesLabel[i].text = "Shear Modulus G12"
            case 4:
                threeDPropertiesLabel[i].text = "Shear Modulus G13"
            case 5:
                threeDPropertiesLabel[i].text = "Shear Modulus G23"
            case 6:
                threeDPropertiesLabel[i].text = "Poisson's Ratio ν12"
            case 7:
                threeDPropertiesLabel[i].text = "Poisson's Ratio ν13"
            case 8:
                threeDPropertiesLabel[i].text = "Poisson's Ratio ν23"
            default:
                break
            }
            threeDPropertiesLabel[i].leftAnchor.constraint(equalTo: threeDPropertiesCard.leftAnchor, constant: 8).isActive = true
            threeDPropertiesLabel[i].widthAnchor.constraint(equalTo: threeDPropertiesCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            threeDPropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                threeDPropertiesLabel[i].topAnchor.constraint(equalTo: threeDPropertiesTitleLabel.bottomAnchor, constant: 8).isActive = true
            case 8:
                threeDPropertiesLabel[i].topAnchor.constraint(equalTo: threeDPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                threeDPropertiesLabel[i].bottomAnchor.constraint(equalTo: threeDPropertiesCard.bottomAnchor, constant: -8).isActive = true
            default:
                threeDPropertiesLabel[i].topAnchor.constraint(equalTo: threeDPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...8 {
            threeDPropertiesResultLabel.append(UILabel())
            threeDPropertiesCard.addSubview(threeDPropertiesResultLabel[i])
            threeDPropertiesResultLabel[i].resultCardLabelRightDesign()
            switch i {
            case 0:
                threeDPropertiesResultLabel[i].text = "Young's Modulus E1"
            case 1:
                threeDPropertiesResultLabel[i].text = "Young's Modulus E2"
            case 2:
                threeDPropertiesResultLabel[i].text = "Young's Modulus E3"
            case 3:
                threeDPropertiesResultLabel[i].text = "Shear Modulus G12"
            case 4:
                threeDPropertiesResultLabel[i].text = "Shear Modulus G13"
            case 5:
                threeDPropertiesResultLabel[i].text = "Shear Modulus G23"
            case 6:
                threeDPropertiesResultLabel[i].text = "Poisson's Ratio ν12"
            case 7:
                threeDPropertiesResultLabel[i].text = "Poisson's Ratio ν13"
            case 8:
                threeDPropertiesResultLabel[i].text = "Poisson's Ratio ν23"
            default:
                break
            }
            threeDPropertiesResultLabel[i].rightAnchor.constraint(equalTo: threeDPropertiesCard.rightAnchor, constant: -8).isActive = true
            threeDPropertiesResultLabel[i].widthAnchor.constraint(equalTo: threeDPropertiesCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            threeDPropertiesResultLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            threeDPropertiesResultLabel[i].centerYAnchor.constraint(equalTo: threeDPropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
        
        
        // second section
        
        inPlanePropertiesCard.resultCardViewDesign()
        inPlanePropertiesCard.topAnchor.constraint(equalTo: threeDPropertiesCard.bottomAnchor, constant: 20).isActive = true
        inPlanePropertiesCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        inPlanePropertiesCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        inPlanePropertiesCard.addSubview(inPlanePropertiesTitleLabel)
        
        inPlanePropertiesTitleLabel.resultCardTitleDesign()
        inPlanePropertiesTitleLabel.text = "In-plane Properties"
        inPlanePropertiesTitleLabel.topAnchor.constraint(equalTo: inPlanePropertiesCard.topAnchor, constant: 0).isActive = true
        inPlanePropertiesTitleLabel.leftAnchor.constraint(equalTo: inPlanePropertiesCard.leftAnchor, constant: 0).isActive = true
        inPlanePropertiesTitleLabel.rightAnchor.constraint(equalTo: inPlanePropertiesCard.rightAnchor, constant: 0).isActive = true
        inPlanePropertiesTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for i in 0...5 {
            inPlanePropertiesLabel.append(UILabel())
            inPlanePropertiesCard.addSubview(inPlanePropertiesLabel[i])
            inPlanePropertiesLabel[i].resultCardLabelLeftDesign()
            switch i {
            case 0:
                inPlanePropertiesLabel[i].text = "Young's Modulus E1"
            case 1:
                inPlanePropertiesLabel[i].text = "Young's Modulus E2"
            case 2:
                inPlanePropertiesLabel[i].text = "Shear Modulus G12"
            case 3:
                inPlanePropertiesLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                inPlanePropertiesLabel[i].text = "Mutual Influence η12,1"
            case 5:
                inPlanePropertiesLabel[i].text = "Mutual Influence η12,2"
            default:
                break
            }
            inPlanePropertiesLabel[i].leftAnchor.constraint(equalTo: inPlanePropertiesCard.leftAnchor, constant: 8).isActive = true
            inPlanePropertiesLabel[i].widthAnchor.constraint(equalTo: inPlanePropertiesCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            inPlanePropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                inPlanePropertiesLabel[i].topAnchor.constraint(equalTo: inPlanePropertiesTitleLabel.bottomAnchor, constant: 8).isActive = true
            case 5:
                inPlanePropertiesLabel[i].topAnchor.constraint(equalTo: inPlanePropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                inPlanePropertiesLabel[i].bottomAnchor.constraint(equalTo: inPlanePropertiesCard.bottomAnchor, constant: -8).isActive = true
            default:
                inPlanePropertiesLabel[i].topAnchor.constraint(equalTo: inPlanePropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...5 {
            inPlanePropertiesResultLabel.append(UILabel())
            inPlanePropertiesCard.addSubview(inPlanePropertiesResultLabel[i])
            inPlanePropertiesResultLabel[i].resultCardLabelRightDesign()
            switch i {
            case 0:
                inPlanePropertiesResultLabel[i].text = "Young's Modulus E1"
            case 1:
                inPlanePropertiesResultLabel[i].text = "Young's Modulus E2"
            case 2:
                inPlanePropertiesResultLabel[i].text = "Shear Modulus G12"
            case 3:
                inPlanePropertiesResultLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                inPlanePropertiesResultLabel[i].text = "Mutual Influence η12,1"
            case 5:
                inPlanePropertiesResultLabel[i].text = "Mutual Influence η12,2"
            default:
                break
            }
            inPlanePropertiesResultLabel[i].rightAnchor.constraint(equalTo: inPlanePropertiesCard.rightAnchor, constant: -8).isActive = true
            inPlanePropertiesResultLabel[i].widthAnchor.constraint(equalTo: inPlanePropertiesCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            inPlanePropertiesResultLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            inPlanePropertiesResultLabel[i].centerYAnchor.constraint(equalTo: inPlanePropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
        
        // third section
        
        flexuralPropertiesCard.resultCardViewDesign()
        flexuralPropertiesCard.topAnchor.constraint(equalTo: inPlanePropertiesCard.bottomAnchor, constant: 20).isActive = true
        flexuralPropertiesCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        flexuralPropertiesCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        flexuralPropertiesCard.addSubview(flexuralPropertiesTitleLabel)
        
        flexuralPropertiesTitleLabel.resultCardTitleDesign()
        flexuralPropertiesTitleLabel.text = "Flexural Properties"
        flexuralPropertiesTitleLabel.topAnchor.constraint(equalTo: flexuralPropertiesCard.topAnchor, constant: 0).isActive = true
        flexuralPropertiesTitleLabel.leftAnchor.constraint(equalTo: flexuralPropertiesCard.leftAnchor, constant: 0).isActive = true
        flexuralPropertiesTitleLabel.rightAnchor.constraint(equalTo: flexuralPropertiesCard.rightAnchor, constant: 0).isActive = true
        flexuralPropertiesTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for i in 0...5 {
            flexuralPropertiesLabel.append(UILabel())
            flexuralPropertiesCard.addSubview(flexuralPropertiesLabel[i])
            flexuralPropertiesLabel[i].resultCardLabelLeftDesign()
            switch i {
            case 0:
                flexuralPropertiesLabel[i].text = "Young's Modulus E1"
            case 1:
                flexuralPropertiesLabel[i].text = "Young's Modulus E2"
            case 2:
                flexuralPropertiesLabel[i].text = "Shear Modulus G12"
            case 3:
                flexuralPropertiesLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                flexuralPropertiesLabel[i].text = "Mutual Influence η12,1"
            case 5:
                flexuralPropertiesLabel[i].text = "Mutual Influence η12,2"
            default:
                break
            }
            flexuralPropertiesLabel[i].leftAnchor.constraint(equalTo: flexuralPropertiesCard.leftAnchor, constant: 8).isActive = true
            flexuralPropertiesLabel[i].widthAnchor.constraint(equalTo: flexuralPropertiesCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            flexuralPropertiesLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                flexuralPropertiesLabel[i].topAnchor.constraint(equalTo: flexuralPropertiesTitleLabel.bottomAnchor, constant: 8).isActive = true
            case 5:
                flexuralPropertiesLabel[i].topAnchor.constraint(equalTo: flexuralPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
                flexuralPropertiesLabel[i].bottomAnchor.constraint(equalTo: flexuralPropertiesCard.bottomAnchor, constant: -8).isActive = true
            default:
                flexuralPropertiesLabel[i].topAnchor.constraint(equalTo: flexuralPropertiesLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...5 {
            flexuralPropertiesResultLabel.append(UILabel())
            flexuralPropertiesCard.addSubview(flexuralPropertiesResultLabel[i])
            flexuralPropertiesResultLabel[i].resultCardLabelRightDesign()
            switch i {
            case 0:
                flexuralPropertiesResultLabel[i].text = "Young's Modulus E1"
            case 1:
                flexuralPropertiesResultLabel[i].text = "Young's Modulus E2"
            case 2:
                flexuralPropertiesResultLabel[i].text = "Shear Modulus G12"
            case 3:
                flexuralPropertiesResultLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                flexuralPropertiesResultLabel[i].text = "Mutual Influence η12,1"
            case 5:
                flexuralPropertiesResultLabel[i].text = "Mutual Influence η12,2"
            default:
                break
            }
            flexuralPropertiesResultLabel[i].rightAnchor.constraint(equalTo: flexuralPropertiesCard.rightAnchor, constant: -8).isActive = true
            flexuralPropertiesResultLabel[i].widthAnchor.constraint(equalTo: flexuralPropertiesCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            flexuralPropertiesResultLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            flexuralPropertiesResultLabel[i].centerYAnchor.constraint(equalTo: flexuralPropertiesLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
    }
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        for i in 0...8 {
            
            if abs(effective3DProperties[i]) > 100000 {
                threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) > 0.0001 {
                threeDPropertiesResultLabel[i].text = String(format: "%.3f", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) < 0.000000000000001 {
                threeDPropertiesResultLabel[i].text = "0"
            }
            else {
                threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            threeDPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...5 {
            
            if abs(effectiveInPlaneProperties[i]) > 100000 {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) > 0.0001 {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3f", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) < 0.000000000000001 {
                inPlanePropertiesResultLabel[i].text = "0"
            }
            else {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            
            if abs(effectiveFlexuralProperties[i]) > 100000 {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) > 0.0001 {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3f", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) < 0.000000000000001 {
                flexuralPropertiesResultLabel[i].text = "0"
            }
            else {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            
            inPlanePropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
            flexuralPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        
        
    }




}
