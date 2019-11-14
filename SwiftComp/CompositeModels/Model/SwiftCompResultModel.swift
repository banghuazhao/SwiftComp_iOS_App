//
//  SwiftCompResultModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/25/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

struct SwiftCompHomogenizationResult: Decodable {
    var swiftcompCwd: String
    var swiftcompCalculationInfo: String
    var beamModelResult: BeamModelResult
    var plateModelResult: PlateModelResult
    var solidModelResult: SolidModelResult
}

struct BeamModelResult: Decodable {
    var effectiveBeamStiffness4by4: EffectiveBeamStiffness4by4
    var effectiveBeamStiffness6by6: EffectiveBeamStiffness6by6
    var thermalCoefficients: ThermalCoefficients
}

struct PlateModelResult: Decodable {
    var effectivePlateStiffness: EffectivePlateStiffness
    var effectivePlateStiffnessRefined: EffectivePlateStiffnessRefined
    var inPlaneProperties: InPlaneProperties
    var flexuralProperties: FlexuralProperties
    var thermalCoefficients: ThermalCoefficients
}

struct SolidModelResult: Decodable {
    var effectiveSolidStiffness: EffectiveSolidStiffness
    var engineeringConstants: EngineeringConstants
    var thermalCoefficients: ThermalCoefficients
}

struct EffectiveBeamStiffness4by4: Decodable {
    var S11: String
    var S12: String
    var S13: String
    var S14: String
    var S22: String
    var S23: String
    var S24: String
    var S33: String
    var S34: String
    var S44: String
}

struct EffectiveBeamStiffness6by6: Decodable {
    var S11: String
    var S12: String
    var S13: String
    var S14: String
    var S15: String
    var S16: String
    var S22: String
    var S23: String
    var S24: String
    var S25: String
    var S26: String
    var S33: String
    var S34: String
    var S35: String
    var S36: String
    var S44: String
    var S45: String
    var S46: String
    var S55: String
    var S56: String
    var S66: String
}

struct EffectivePlateStiffness: Decodable {
    var A11: String
    var A12: String
    var A16: String
    var A22: String
    var A26: String
    var A66: String
    var B11: String
    var B12: String
    var B16: String
    var B22: String
    var B26: String
    var B66: String
    var D11: String
    var D12: String
    var D16: String
    var D22: String
    var D26: String
    var D66: String
}

struct EffectivePlateStiffnessRefined: Decodable {
    var C11: String
    var C12: String
    var C22: String
}

struct InPlaneProperties: Decodable {
    var E1: String
    var E2: String
    var G12: String
    var nu12: String
    var eta121: String
    var eta122: String
}

struct FlexuralProperties: Decodable {
    var E1: String
    var E2: String
    var G12: String
    var nu12: String
    var eta121: String
    var eta122: String
}

struct ThermalCoefficients: Decodable {
    var alpha11: String
    var alpha22: String
    var alpha33: String
    var alpha23: String
    var alpha13: String
    var alpha12: String
}

struct EffectiveSolidStiffness: Decodable {
    var C11: String
    var C12: String
    var C13: String
    var C14: String
    var C15: String
    var C16: String
    var C22: String
    var C23: String
    var C24: String
    var C25: String
    var C26: String
    var C33: String
    var C34: String
    var C35: String
    var C36: String
    var C44: String
    var C45: String
    var C46: String
    var C55: String
    var C56: String
    var C66: String
}

struct EngineeringConstants: Decodable {
    var E1: String
    var E2: String
    var E3: String
    var G12: String
    var G13: String
    var G23: String
    var nu12: String
    var nu13: String
    var nu23: String
}
