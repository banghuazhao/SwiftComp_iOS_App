//
//  LaminateResults.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/14/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class LaminateResults: UIViewController {
    

    var effective3DProperties = [Double](repeating: 0, count: 9)
    var effectiveInPlaneProperties = [Double](repeating: 0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0, count: 6)


    @IBOutlet var resultViews: [UIView]!
    @IBOutlet var effective3DPropertiesLabel: [UILabel]!
    @IBOutlet var effectiveInPlanePropertiesLabel: [UILabel]!
    @IBOutlet var effectiveFlexuralPropertiesLabel: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...2 {
            resultViews[i].resultViewDesign()
        }
        
        for i in 0...8 {
            
            if abs(effective3DProperties[i]) > 100000 {
                effective3DPropertiesLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) > 0.0001 {
                effective3DPropertiesLabel[i].text = String(format: "%.3f", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) > 0.000001 {
                effective3DPropertiesLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            else {
                effective3DPropertiesLabel[i].text = "0"
            }
            
            effective3DPropertiesLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...5 {
            
            if abs(effectiveInPlaneProperties[i]) > 100000 {
                effectiveInPlanePropertiesLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) > 0.0001 {
                effectiveInPlanePropertiesLabel[i].text = String(format: "%.3f", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) > 0.000001 {
                effectiveInPlanePropertiesLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            else {
                effectiveInPlanePropertiesLabel[i].text = "0"
            }
            
            if abs(effectiveFlexuralProperties[i]) > 100000 {
                effectiveFlexuralPropertiesLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) > 0.0001 {
                effectiveFlexuralPropertiesLabel[i].text = String(format: "%.3f", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) > 0.000001 {
                effectiveFlexuralPropertiesLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            else {
                effectiveFlexuralPropertiesLabel[i].text = "0"
            }
            
            effectiveFlexuralPropertiesLabel[i].adjustsFontSizeToFitWidth = true
            effectiveInPlanePropertiesLabel[i].adjustsFontSizeToFitWidth = true
        }
      
    }

}


