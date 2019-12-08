//
//  VolumeFraction.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/7/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class VolumeFraction {
    
    var value: Double?
    
    var cellLength: Double?
    var cellLengthText: String {
        didSet {
            cellLength = Double(cellLengthText)
            guard let cellLength = cellLength else { return }
            if cellLength <= 0.0 {
                self.cellLength = nil
            }
        }
    }
    
    let maxVolumeFraction: Double = 1.0
    
    init(value: Double, cellLength: Double) {
        self.value = value
        self.cellLength = cellLength
        cellLengthText = "\(cellLength)"
    }
}
