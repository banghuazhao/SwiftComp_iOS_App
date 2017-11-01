//
//  UDFRCResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class UDFRCResult: UIViewController {

    var engineeringConstants = [Double](repeating: 0.0, count: 7)
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    var materialPropertyName = MaterialPropertyName()
    var materialPropertyLabel = MaterialPropertyLabel()
    
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
        
        navigationItem.title = "Result"
        
    }
    
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 700)
        scrollView.addSubview(engineeringConstantsCard)
        scrollView.addSubview(planeStressReducedComplianceCard)
        scrollView.addSubview(planeStressReducedStiffnessCard)
        
        
        // first section
        
        engineeringConstantsTitleLabel.text = "3D Properties"
        for i in 0...6 {
            engineeringConstantsLabel.append(UILabel())
            engineeringConstantsLabel[i].text = materialPropertyName.transverseIsotropic[i]
            
            engineeringConstantsResultLabel.append(UILabel())
        }
        
        creatResultListCard(resultCard: engineeringConstantsCard, title: engineeringConstantsTitleLabel, label: engineeringConstantsLabel, result: engineeringConstantsResultLabel, aboveConstraint: scrollView.topAnchor, under: scrollView)
        
        
        // second section
        for _ in 0...8 {
            planeStressReducedComplianceResultLabel.append(UILabel())
        }
        planeStressReducedComplianceTitleLabel.text = "Plane-stress Reduced Compliance"
        createResult3by3MatrixCard(resultCard: planeStressReducedComplianceCard, title: planeStressReducedComplianceTitleLabel, result: planeStressReducedComplianceResultLabel, aboveConstraint: engineeringConstantsCard.bottomAnchor, under: scrollView)
        
  
        // third section
        
        for _ in 0...8 {
            planeStressReducedStiffnessResultLabel.append(UILabel())
        }
        planeStressReducedStiffnessTitleLabel.text = "Plane-stress Reduced Stiffness"
        createResult3by3MatrixCard(resultCard: planeStressReducedStiffnessCard, title: planeStressReducedStiffnessTitleLabel, result: planeStressReducedStiffnessResultLabel, aboveConstraint: planeStressReducedComplianceCard.bottomAnchor, under: scrollView)
        
    }
    
    
    
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        for i in 0...6 {
            
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
