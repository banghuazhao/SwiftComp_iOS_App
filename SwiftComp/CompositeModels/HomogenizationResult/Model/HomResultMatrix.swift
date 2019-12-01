//
//  HomResultMatrix.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class HomResultMatrix {
    private var maxValue: Double = 0.0
    var valueText: String
    
    init(valueText: String) {
        self.valueText = valueText
        setupValueText()
    }
    
    init(valueText: String, valueDict: [String: String]) {
        self.valueText = valueText
        maxValue = Array(valueDict.values).compactMap { Double($0) }.max() ?? 0.0
        setupValueText()
    }
    
    private func setupValueText() {
        guard let value = Double(valueText) else {
            valueText = "Not available"
            return
        }
        if abs(value) >= 1e6 {
            valueText = String(format: "%.3e", value)
        } else if abs(value) >= 0.001 {
            valueText = String(format: "%.3f", value)
        } else if value == 0.0 {
            valueText = "0"
        } else {
            valueText = String(format: "%.3e", value)
        }
        
        if value != 0 {
            if abs(maxValue / value) > 1e12 {
                valueText = "0"
            }
        } else {
            valueText = "0"
        }
    }
}

