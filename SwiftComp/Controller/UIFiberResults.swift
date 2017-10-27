//
//  UIFiberResults.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/6/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class UIFiberResults: UIViewController {
    
    var e1 = 0.0, e2 = 0.0, g12 = 0.0, v12 = 0.0, v23 = 0.0
    var engineeringConstants = [Double](repeating: 0, count: 9)
    var Se = [Double](repeating: 0, count: 9)
    var Q = [Double](repeating: 0, count: 9)

    @IBOutlet var effectiveEngineeringConstants: [UILabel]!
    @IBOutlet var reducedComplianceMatrix: [UILabel]!
    @IBOutlet var reducedStiffnessMatrix: [UILabel]!
    
    
    @IBOutlet var resultsView: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsView[0].resultViewDesign()
        resultsView[1].resultViewDesign()
        resultsView[2].resultViewDesign()

        engineeringConstants = [e1, e2, g12, v12, v23]
        
        for i in 0...4 {
            if abs(engineeringConstants[i]) > 100000 {
                effectiveEngineeringConstants[i].text = String(format: "%.3e", engineeringConstants[i])
            }
            else if abs(engineeringConstants[i]) > 0.0001 {
                effectiveEngineeringConstants[i].text = String(format: "%.3f", engineeringConstants[i])
            }
            else if abs(engineeringConstants[i]) > 0.000001 {
                effectiveEngineeringConstants[i].text = String(format: "%.3e", engineeringConstants[i])
            }
            else {
                effectiveEngineeringConstants[i].text = "0"
            }
            
            effectiveEngineeringConstants[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...8 {
            if abs(Se[i]) > 100000 {
                reducedComplianceMatrix[i].text = String(format: "%.3e", Se[i])
            }
            else if abs(Se[i]) > 0.0001 {
                reducedComplianceMatrix[i].text = String(format: "%.3f", Se[i])
            }
            else if abs(Se[i]) > 0.000001 {
                reducedComplianceMatrix[i].text = String(format: "%.3e", Se[i])
            }
            else {
                reducedComplianceMatrix[i].text = "0"
            }
            
            if abs(Q[i]) > 100000 {
                reducedStiffnessMatrix[i].text = String(format: "%.3e", Q[i])
            }
            else if abs(Q[i]) > 0.0001 {
                reducedStiffnessMatrix[i].text = String(format: "%.3f", Q[i])
            }
            else if abs(Q[i]) > 0.000001 {
                reducedStiffnessMatrix[i].text = String(format: "%.3e", Q[i])
            }
            else {
                reducedStiffnessMatrix[i].text = "0"
            }
            
            reducedComplianceMatrix[i].adjustsFontSizeToFitWidth = true
            reducedStiffnessMatrix[i].adjustsFontSizeToFitWidth = true
        }
        
        
    }

}


