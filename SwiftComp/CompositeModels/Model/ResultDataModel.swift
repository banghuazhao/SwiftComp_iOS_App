//
//  ResultDataModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class ResultData {
    var swiftcompCwd: String

    var swiftcompCalculationInfo: String

    var effectiveBeamStiffness4by4: [Double]
    var effectiveBeamStiffness6by6: [Double]

    var AMatrix: [Double]
    var BMatrix: [Double]
    var DMatrix: [Double]
    var CMatrix: [Double]
    var effectiveInplaneProperties: [Double]
    var effectiveFlexuralProperties: [Double]

    var effectiveSolidStiffnessMatrix: [Double]
    var engineeringConstantsOrthotropic: [Double]

    var effectiveThermalCoefficients: [Double]

    init() {
        swiftcompCwd = ""

        swiftcompCalculationInfo = ""

        effectiveBeamStiffness4by4 = [Double](repeating: 0.0, count: 16)
        effectiveBeamStiffness6by6 = [Double](repeating: 0.0, count: 36)

        AMatrix = [Double](repeating: 0.0, count: 9)
        BMatrix = [Double](repeating: 0.0, count: 9)
        DMatrix = [Double](repeating: 0.0, count: 9)
        CMatrix = [Double](repeating: 0.0, count: 4)
        effectiveInplaneProperties = [Double](repeating: 0.0, count: 6)
        effectiveFlexuralProperties = [Double](repeating: 0.0, count: 6)

        effectiveSolidStiffnessMatrix = [Double](repeating: 0.0, count: 36)
        engineeringConstantsOrthotropic = [Double](repeating: 0.0, count: 9)

        effectiveThermalCoefficients = [Double](repeating: 0.0, count: 6)
    }
}
