//
//  UDFRCResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class UDFRCResult: UIViewController {

    var engineeringConstants = [Double](repeating: 0.0, count: 5)
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    var scrollView: UIScrollView = UIScrollView()
    
    // First section
    
    var engineeringConstantsCard: UIView = UIView()
    
    var engineeringConstantsTitleLabel: UILabel = UILabel()
    
    var engineeringConstantsLabel: [UILabel] = []
    
    var engineeringConstantsResultLabel: [UILabel] = []
    
    
    // Second section
    
    var planeStressReducedComplianceCard: UIView = UIView()
    
    var planeStressReducedComplianceTitleLabel: UILabel = UILabel()
    
    var planeStressReducedComplianceResultLabel: [UILabel] = []
    
    
    // Third section
    
    var planeStressReducedStiffnessCard: UIView = UIView()
    
    var planeStressReducedStiffnessTitleLabel: UILabel = UILabel()
    
    var planeStressReducedStiffnessResultLabel: [UILabel] = []
    
    
    
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
        scrollView.addSubview(engineeringConstantsCard)
        scrollView.addSubview(planeStressReducedComplianceCard)
        scrollView.addSubview(planeStressReducedStiffnessCard)
        
        
        // first section
        
        engineeringConstantsCard.resultCardViewDesign()
        engineeringConstantsCard.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        engineeringConstantsCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        engineeringConstantsCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        engineeringConstantsCard.addSubview(engineeringConstantsTitleLabel)
        
        engineeringConstantsTitleLabel.resultCardTitleDesign()
        engineeringConstantsTitleLabel.text = "3D Properties"
        engineeringConstantsTitleLabel.topAnchor.constraint(equalTo: engineeringConstantsCard.topAnchor, constant: 0).isActive = true
        engineeringConstantsTitleLabel.leftAnchor.constraint(equalTo: engineeringConstantsCard.leftAnchor, constant: 0).isActive = true
        engineeringConstantsTitleLabel.rightAnchor.constraint(equalTo: engineeringConstantsCard.rightAnchor, constant: 0).isActive = true
        engineeringConstantsTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for i in 0...4 {
            engineeringConstantsLabel.append(UILabel())
            engineeringConstantsCard.addSubview(engineeringConstantsLabel[i])
            engineeringConstantsLabel[i].resultCardLabelLeftDesign()
            switch i {
            case 0:
                engineeringConstantsLabel[i].text = "Young's Modulus E1"
            case 1:
                engineeringConstantsLabel[i].text = "Young's Modulus E2"
            case 2:
                engineeringConstantsLabel[i].text = "Shear Modulus G12"
            case 3:
                engineeringConstantsLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                engineeringConstantsLabel[i].text = "Poisson's Ratio ν23"
            default:
                break
            }
            engineeringConstantsLabel[i].leftAnchor.constraint(equalTo: engineeringConstantsCard.leftAnchor, constant: 8).isActive = true
            engineeringConstantsLabel[i].widthAnchor.constraint(equalTo: engineeringConstantsCard.widthAnchor, multiplier: 0.55, constant: -16).isActive = true
            engineeringConstantsLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            switch i {
            case 0:
                engineeringConstantsLabel[i].topAnchor.constraint(equalTo: engineeringConstantsTitleLabel.bottomAnchor, constant: 8).isActive = true
            case 4:
                engineeringConstantsLabel[i].topAnchor.constraint(equalTo: engineeringConstantsLabel[i-1].bottomAnchor, constant: 8).isActive = true
                engineeringConstantsLabel[i].bottomAnchor.constraint(equalTo: engineeringConstantsCard.bottomAnchor, constant: -8).isActive = true
            default:
                engineeringConstantsLabel[i].topAnchor.constraint(equalTo: engineeringConstantsLabel[i-1].bottomAnchor, constant: 8).isActive = true
            }
        }
        
        for i in 0...4 {
            engineeringConstantsResultLabel.append(UILabel())
            engineeringConstantsCard.addSubview(engineeringConstantsResultLabel[i])
            engineeringConstantsResultLabel[i].resultCardLabelRightDesign()
            switch i {
            case 0:
                engineeringConstantsResultLabel[i].text = "Young's Modulus E1"
            case 1:
                engineeringConstantsResultLabel[i].text = "Young's Modulus E2"
            case 2:
                engineeringConstantsResultLabel[i].text = "Shear Modulus G12"
            case 3:
                engineeringConstantsResultLabel[i].text = "Poisson's Ratio ν12"
            case 4:
                engineeringConstantsResultLabel[i].text = "Poisson's Ratio ν23"
            default:
                break
            }
            engineeringConstantsResultLabel[i].rightAnchor.constraint(equalTo: engineeringConstantsCard.rightAnchor, constant: -8).isActive = true
            engineeringConstantsResultLabel[i].widthAnchor.constraint(equalTo: engineeringConstantsCard.widthAnchor, multiplier: 0.45, constant: -16).isActive = true
            engineeringConstantsResultLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            engineeringConstantsResultLabel[i].centerYAnchor.constraint(equalTo: engineeringConstantsLabel[i].centerYAnchor, constant: 0).isActive = true
        }
        
        
        
        
        // second section
        
        planeStressReducedComplianceCard.resultCardViewDesign()
        planeStressReducedComplianceCard.topAnchor.constraint(equalTo: engineeringConstantsCard.bottomAnchor, constant: 20).isActive = true
        planeStressReducedComplianceCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        planeStressReducedComplianceCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        planeStressReducedComplianceCard.addSubview(planeStressReducedComplianceTitleLabel)
        
        planeStressReducedComplianceTitleLabel.resultCardTitleDesign()
        planeStressReducedComplianceTitleLabel.text = "Plane-stress Reduced Compliance"
        planeStressReducedComplianceTitleLabel.topAnchor.constraint(equalTo: planeStressReducedComplianceCard.topAnchor, constant: 0).isActive = true
        planeStressReducedComplianceTitleLabel.leftAnchor.constraint(equalTo: planeStressReducedComplianceCard.leftAnchor, constant: 0).isActive = true
        planeStressReducedComplianceTitleLabel.rightAnchor.constraint(equalTo: planeStressReducedComplianceCard.rightAnchor, constant: 0).isActive = true
        planeStressReducedComplianceTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        for i in 0...8 {
            planeStressReducedComplianceResultLabel.append(UILabel())
            planeStressReducedComplianceCard.addSubview(planeStressReducedComplianceResultLabel[i])
            planeStressReducedComplianceResultLabel[i].resultCardLabelRightDesign()
            planeStressReducedComplianceResultLabel[i].textAlignment = .center
            planeStressReducedComplianceResultLabel[i].widthAnchor.constraint(equalTo: planeStressReducedComplianceCard.widthAnchor, multiplier: 0.3).isActive = true
            planeStressReducedComplianceResultLabel[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        planeStressReducedComplianceResultLabel[0].leftAnchor.constraint(equalTo: planeStressReducedComplianceCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[0].topAnchor.constraint(equalTo: planeStressReducedComplianceTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedComplianceResultLabel[1].centerXAnchor.constraint(equalTo: planeStressReducedComplianceCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[1].topAnchor.constraint(equalTo: planeStressReducedComplianceTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedComplianceResultLabel[2].rightAnchor.constraint(equalTo: planeStressReducedComplianceCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedComplianceResultLabel[2].topAnchor.constraint(equalTo: planeStressReducedComplianceTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        
        planeStressReducedComplianceResultLabel[3].leftAnchor.constraint(equalTo: planeStressReducedComplianceCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[3].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[1].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedComplianceResultLabel[4].centerXAnchor.constraint(equalTo: planeStressReducedComplianceCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[4].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[1].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedComplianceResultLabel[5].rightAnchor.constraint(equalTo: planeStressReducedComplianceCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedComplianceResultLabel[5].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[1].bottomAnchor, constant: 8).isActive = true
        

        planeStressReducedComplianceResultLabel[6].leftAnchor.constraint(equalTo: planeStressReducedComplianceCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[6].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[4].bottomAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[6].bottomAnchor.constraint(equalTo: planeStressReducedComplianceCard.bottomAnchor, constant: -8).isActive = true
        
        planeStressReducedComplianceResultLabel[7].centerXAnchor.constraint(equalTo: planeStressReducedComplianceCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedComplianceResultLabel[7].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[4].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedComplianceResultLabel[8].rightAnchor.constraint(equalTo: planeStressReducedComplianceCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedComplianceResultLabel[8].topAnchor.constraint(equalTo: planeStressReducedComplianceResultLabel[4].bottomAnchor, constant: 8).isActive = true
        
        
        
        // third section
        
        planeStressReducedStiffnessCard.resultCardViewDesign()
        planeStressReducedStiffnessCard.topAnchor.constraint(equalTo: planeStressReducedComplianceCard.bottomAnchor, constant: 20).isActive = true
        planeStressReducedStiffnessCard.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        planeStressReducedStiffnessCard.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        planeStressReducedStiffnessCard.addSubview(planeStressReducedStiffnessTitleLabel)
        
        planeStressReducedStiffnessTitleLabel.resultCardTitleDesign()
        planeStressReducedStiffnessTitleLabel.text = "Plane-stress Reduced Stiffness"
        planeStressReducedStiffnessTitleLabel.topAnchor.constraint(equalTo: planeStressReducedStiffnessCard.topAnchor, constant: 0).isActive = true
        planeStressReducedStiffnessTitleLabel.leftAnchor.constraint(equalTo: planeStressReducedStiffnessCard.leftAnchor, constant: 0).isActive = true
        planeStressReducedStiffnessTitleLabel.rightAnchor.constraint(equalTo: planeStressReducedStiffnessCard.rightAnchor, constant: 0).isActive = true
        planeStressReducedStiffnessTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        for i in 0...8 {
            planeStressReducedStiffnessResultLabel.append(UILabel())
            planeStressReducedStiffnessCard.addSubview(planeStressReducedStiffnessResultLabel[i])
            planeStressReducedStiffnessResultLabel[i].resultCardLabelRightDesign()
            planeStressReducedStiffnessResultLabel[i].textAlignment = .center
            planeStressReducedStiffnessResultLabel[i].widthAnchor.constraint(equalTo: planeStressReducedStiffnessCard.widthAnchor, multiplier: 0.3).isActive = true
            planeStressReducedStiffnessResultLabel[i].heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        planeStressReducedStiffnessResultLabel[0].leftAnchor.constraint(equalTo: planeStressReducedStiffnessCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[0].topAnchor.constraint(equalTo: planeStressReducedStiffnessTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedStiffnessResultLabel[1].centerXAnchor.constraint(equalTo: planeStressReducedStiffnessCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[1].topAnchor.constraint(equalTo: planeStressReducedStiffnessTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedStiffnessResultLabel[2].rightAnchor.constraint(equalTo: planeStressReducedStiffnessCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedStiffnessResultLabel[2].topAnchor.constraint(equalTo: planeStressReducedStiffnessTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        
        planeStressReducedStiffnessResultLabel[3].leftAnchor.constraint(equalTo: planeStressReducedStiffnessCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[3].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[1].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedStiffnessResultLabel[4].centerXAnchor.constraint(equalTo: planeStressReducedStiffnessCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[4].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[1].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedStiffnessResultLabel[5].rightAnchor.constraint(equalTo: planeStressReducedStiffnessCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedStiffnessResultLabel[5].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[1].bottomAnchor, constant: 8).isActive = true
        
        
        planeStressReducedStiffnessResultLabel[6].leftAnchor.constraint(equalTo: planeStressReducedStiffnessCard.leftAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[6].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[4].bottomAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[6].bottomAnchor.constraint(equalTo: planeStressReducedStiffnessCard.bottomAnchor, constant: -8).isActive = true
        
        planeStressReducedStiffnessResultLabel[7].centerXAnchor.constraint(equalTo: planeStressReducedStiffnessCard.centerXAnchor, constant: 8).isActive = true
        planeStressReducedStiffnessResultLabel[7].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[4].bottomAnchor, constant: 8).isActive = true
        
        planeStressReducedStiffnessResultLabel[8].rightAnchor.constraint(equalTo: planeStressReducedStiffnessCard.rightAnchor, constant: -8).isActive = true
        planeStressReducedStiffnessResultLabel[8].topAnchor.constraint(equalTo: planeStressReducedStiffnessResultLabel[4].bottomAnchor, constant: 8).isActive = true
        
        
    }
    
    
    
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        for i in 0...4 {
            
            if abs(engineeringConstants[i]) > 100000 {
                engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstants[i])
            }
            else if abs(engineeringConstants[i]) > 0.0001 {
                engineeringConstantsResultLabel[i].text = String(format: "%.3f", engineeringConstants[i])
            }
            else if abs(engineeringConstants[i]) < 0.000000000000001 {
                engineeringConstantsResultLabel[i].text = "0"
            }
            else {
                engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstants[i])
            }
            engineeringConstantsResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...8 {
            
            if abs(planeStressReducedCompliance[i]) > 100000 {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3e", planeStressReducedCompliance[i])
            }
            else if abs(planeStressReducedCompliance[i]) > 0.0001 {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3f", planeStressReducedCompliance[i])
            }
            else if abs(planeStressReducedCompliance[i]) < 0.000000000000001 {
                planeStressReducedComplianceResultLabel[i].text = "0"
            }
            else {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3e", planeStressReducedCompliance[i])
            }
            planeStressReducedComplianceResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...8 {
            
            if abs(planeStressReducedStiffness[i]) > 100000 {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3e", planeStressReducedStiffness[i])
            }
            else if abs(planeStressReducedStiffness[i]) > 0.0001 {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3f", planeStressReducedStiffness[i])
            }
            else if abs(planeStressReducedStiffness[i]) < 0.000000000000001 {
                planeStressReducedStiffnessResultLabel[i].text = "0"
            }
            else {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3e", planeStressReducedStiffness[i])
            }
            planeStressReducedStiffnessResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
    }


}
