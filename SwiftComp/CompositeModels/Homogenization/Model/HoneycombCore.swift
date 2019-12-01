//
//  HoneycombCore.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/24/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class HoneycombCore {
    var coreLength: Double?
    var coreThickness: Double?
    var coreHeight: Double?
    
    var coreLenthText: String {
        didSet {
            coreLength = Double(coreLenthText)
            guard let coreLengthGuard = coreLength, coreLengthGuard > 0 else {
                coreLength = nil
                return
            }
        }
    }
    var coreThicknessText: String {
        didSet {
            coreThickness = Double(coreThicknessText)
            guard let coreThicknessGuard = coreThickness, coreThicknessGuard > 0 else {
                coreThickness = nil
                return
            }
        }
    }
    var coreHeightText: String {
        didSet {
            coreHeight = Double(coreHeightText)
            guard let coreHeightGuard = coreHeight, coreHeightGuard > 0 else {
                coreHeight = nil
                return
            }
        }
    }
    
    init(coreLength: Double, coreThickness: Double, coreHeight: Double) {
        self.coreLength = coreLength
        self.coreThickness = coreThickness
        self.coreHeight = coreHeight
        coreLenthText = "\(coreLength)"
        coreThicknessText = "\(coreThickness)"
        coreHeightText = "\(coreHeight)"
    }
}
