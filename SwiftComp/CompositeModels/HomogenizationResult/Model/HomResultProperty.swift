//
//  HomResultProperty.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation


class HomResultProperty {
    var name: String
    var valueText: String
    
    init(name: String, valueText: String) {
        self.name = name
        self.valueText = valueText
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
    }
}
