//
//  HomPlateResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomPlateResult {
    var effectivePlateStiffness: [String: Any]?
    var effectivePlateStiffnessRefined: [String: Any]?
    var inPlaneProperties: [String: Any]?
    var flexuralProperties: [String: Any]?
    var thermalCoefficients: [String: Any]?

    var effectivePlateStiffnessArray: [HomResultMatrix] = []
    var effectivePlateStiffnessRefinedArray: [HomResultProperty] = []
    var flexuralPropertiesArray: [HomResultProperty] = []
    var inPlanePropertiesArray: [HomResultProperty] = []
    var thermalCoefficientsArray: [HomResultProperty] = []

    init(typeOfAnalysis: TypeOfAnalysis, dataJSON: JSON) {
        effectivePlateStiffness = dataJSON["plateModelResult"]["effectivePlateStiffness"].dictionaryObject
        effectivePlateStiffnessRefined = dataJSON["plateModelResult"]["effectivePlateStiffnessRefined"].dictionaryObject
        inPlaneProperties = dataJSON["plateModelResult"]["inPlaneProperties"].dictionaryObject
        flexuralProperties = dataJSON["plateModelResult"]["flexuralProperties"].dictionaryObject

        setEffectivePlateStiffness()
        seteffectivePlateStiffnessRefined()
        setInPlanePropertiesArray()
        setFlexuralPropertiesArray()

        if typeOfAnalysis == .thermoElastic {
            thermalCoefficients = dataJSON["plateModelResult"]["thermalCoefficients"].dictionaryObject
            setThermalCoefficientsArray()
        }
    }

    init(typeOfAnalysis: TypeOfAnalysis, structuralModel: StructuralModel, effectivePlateStiffness: [String: String], inPlaneProperties: [String: String], flexuralProperties: [String: String], thermalCoefficients: [String: String]?) {
        self.effectivePlateStiffness = effectivePlateStiffness
        self.effectivePlateStiffnessRefined = [:]
        self.inPlaneProperties = inPlaneProperties
        self.flexuralProperties = flexuralProperties
        setEffectivePlateStiffness()
        seteffectivePlateStiffnessRefined()
        setInPlanePropertiesArray()
        setFlexuralPropertiesArray()
        if typeOfAnalysis == .thermoElastic {
            self.thermalCoefficients = thermalCoefficients
            setThermalCoefficientsArray()
        }
    }

    private func setEffectivePlateStiffness() {
        guard let effectivePlateStiffness = effectivePlateStiffness as? [String: String] else { return }
        effectivePlateStiffnessArray = [
            HomResultMatrix(valueText: effectivePlateStiffness["A11"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B11"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B16"] ?? ""),

            HomResultMatrix(valueText: effectivePlateStiffness["A12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A22"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B22"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B26"] ?? ""),

            HomResultMatrix(valueText: effectivePlateStiffness["A16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["A66"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B66"] ?? ""),

            HomResultMatrix(valueText: effectivePlateStiffness["B11"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D11"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D16"] ?? ""),

            HomResultMatrix(valueText: effectivePlateStiffness["B12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B22"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D12"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D22"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D26"] ?? ""),

            HomResultMatrix(valueText: effectivePlateStiffness["B16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["B66"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D16"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D26"] ?? ""),
            HomResultMatrix(valueText: effectivePlateStiffness["D66"] ?? ""),
        ]
    }

    private func seteffectivePlateStiffnessRefined() {
        guard let effectivePlateStiffnessRefined = effectivePlateStiffnessRefined as? [String: String] else { return }
        effectivePlateStiffnessRefinedArray = [
            HomResultProperty(name: "Matrix Component C₁₁", valueText: effectivePlateStiffnessRefined["C11"] ?? ""),
            HomResultProperty(name: "Matrix Component C₁₂", valueText: effectivePlateStiffnessRefined["C12"] ?? ""),
            HomResultProperty(name: "Matrix Component C₂₂", valueText: effectivePlateStiffnessRefined["C22"] ?? ""),
        ]
    }

    private func setInPlanePropertiesArray() {
        guard let inPlaneProperties = inPlaneProperties as? [String: String] else { return }
        inPlanePropertiesArray = [
            HomResultProperty(name: "Young's Modulus E₁", valueText: inPlaneProperties["E1"] ?? ""),
            HomResultProperty(name: "Young's Modulus E₂", valueText: inPlaneProperties["E2"] ?? ""),
            HomResultProperty(name: "Shear Modulus G₁₂", valueText: inPlaneProperties["G12"] ?? ""),
            HomResultProperty(name: "Poisson's Ratio ν₁₂", valueText: inPlaneProperties["nu12"] ?? ""),
            HomResultProperty(name: "Mutual Influence η₁₂‚₁", valueText: inPlaneProperties["eta121"] ?? ""),
            HomResultProperty(name: "Mutual Influencet η₁₂‚₂", valueText: inPlaneProperties["eta122"] ?? ""),
        ]
    }

    private func setFlexuralPropertiesArray() {
        guard let flexuralProperties = flexuralProperties as? [String: String] else { return }
        flexuralPropertiesArray = [
            HomResultProperty(name: "Young's Modulus E₁", valueText: flexuralProperties["E1"] ?? ""),
            HomResultProperty(name: "Young's Modulus E₂", valueText: flexuralProperties["E2"] ?? ""),
            HomResultProperty(name: "Shear Modulus G₁₂", valueText: flexuralProperties["G12"] ?? ""),
            HomResultProperty(name: "Poisson's Ratio ν₁₂", valueText: flexuralProperties["nu12"] ?? ""),
            HomResultProperty(name: "Mutual Influence η₁₂‚₁", valueText: flexuralProperties["eta121"] ?? ""),
            HomResultProperty(name: "Mutual Influencet η₁₂‚₂", valueText: flexuralProperties["eta122"] ?? ""),
        ]
    }

    private func setThermalCoefficientsArray() {
        guard let thermalCoefficients = thermalCoefficients as? [String: String] else { return }
        thermalCoefficientsArray = [
            HomResultProperty(name: "CTE α₁₁", valueText: thermalCoefficients["alpha11"] ?? ""),
            HomResultProperty(name: "CTE α₂₂", valueText: thermalCoefficients["alpha22"] ?? ""),
            HomResultProperty(name: "CTE α₃₃", valueText: thermalCoefficients["alpha33"] ?? ""),
            HomResultProperty(name: "CTE α₂₃", valueText: thermalCoefficients["alpha23"] ?? ""),
            HomResultProperty(name: "CTE α₁₃", valueText: thermalCoefficients["alpha13"] ?? ""),
            HomResultProperty(name: "CTE α₁₂", valueText: thermalCoefficients["alpha12"] ?? ""),
        ]
    }
}
