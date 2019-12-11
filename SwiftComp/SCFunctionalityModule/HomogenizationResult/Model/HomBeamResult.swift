//
//  HomBeamResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomBeamResult {
    var effectiveBeamStiffness4by4: [String: Any]?
    var effectiveBeamStiffness6by6: [String: Any]?
    var thermalCoefficients: [String: Any]?

    var effectiveBeamStiffness4by4Array: [HomResultMatrix] = []
    var effectiveBeamStiffness6by6Array: [HomResultMatrix] = []
    var thermalCoefficientsArray: [HomResultProperty] = []

    init(typeOfAnalysis: TypeOfAnalysis, structuralModel: StructuralModel, dataJSON: JSON) {
        if structuralModel.model == .beam(.eulerBernoulli) {
            effectiveBeamStiffness4by4 = dataJSON["beamModelResult"]["effectiveBeamStiffness4by4"].dictionaryObject
        } else {
            effectiveBeamStiffness6by6 = dataJSON["beamModelResult"]["effectiveBeamStiffness6by6"].dictionaryObject
        }

        setEffectiveBeamStiffness4by4()
        setEffectiveBeamStiffness6by6()

        if typeOfAnalysis == .thermoElastic {
            thermalCoefficients = dataJSON["beamModelResult"]["thermalCoefficients"].dictionaryObject
            setThermalCoefficientsArray()
        }
    }

    private func setEffectiveBeamStiffness4by4() {
        guard let effectiveBeamStiffness4by4 = effectiveBeamStiffness4by4 as? [String: String] else { return }
        effectiveBeamStiffness4by4Array = [
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S11"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S12"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S13"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S14"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S12"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S22"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S23"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S24"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S13"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S23"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S33"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S34"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S14"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S24"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S34"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness4by4["S44"] ?? ""),
        ]
    }

    private func setEffectiveBeamStiffness6by6() {
        guard let effectiveBeamStiffness6by6 = effectiveBeamStiffness6by6 as? [String: String] else { return }
        effectiveBeamStiffness6by6Array = [
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S11"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S12"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S13"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S14"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S15"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S16"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S12"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S22"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S23"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S24"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S25"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S26"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S13"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S23"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S33"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S34"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S35"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S36"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S14"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S24"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S34"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S44"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S45"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S46"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S15"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S25"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S35"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S45"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S55"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S56"] ?? ""),

            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S16"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S26"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S36"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S46"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S56"] ?? ""),
            HomResultMatrix(valueText: effectiveBeamStiffness6by6["S66"] ?? ""),
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

// MARK: - public function

extension HomBeamResult {
    func getSharedResultText() -> String {
        var result = ""
        if effectiveBeamStiffness4by4 != nil {
            result += "Effetive Beam Stiffness Matrix:\n"
            for i in 0...3 {
                result += effectiveBeamStiffness4by4Array[i * 4].valueText + "\t" +
                    effectiveBeamStiffness4by4Array[i * 4 + 1].valueText + "\t" +
                    effectiveBeamStiffness4by4Array[i * 4 + 2].valueText + "\t" +
                    effectiveBeamStiffness4by4Array[i * 4 + 3].valueText + "\n"
            }
        } else {
            result += "Effetive Beam Stiffness Matrix (Refined):\n"
            for i in 0...5 {
                result += effectiveBeamStiffness6by6Array[i * 6].valueText + "\t" +
                    effectiveBeamStiffness6by6Array[i * 6 + 1].valueText + "\t" +
                    effectiveBeamStiffness6by6Array[i * 6 + 2].valueText + "\t" +
                    effectiveBeamStiffness6by6Array[i * 6 + 3].valueText + "\t" +
                    effectiveBeamStiffness6by6Array[i * 6 + 4].valueText + "\t" +
                    effectiveBeamStiffness6by6Array[i * 6 + 5].valueText + "\n"
            }
        }

        if thermalCoefficients != nil {
            result += "\n"
            result += "Thermal Coefficients:\n"
            for i in 0...thermalCoefficientsArray.count-1 {
                result += "\(thermalCoefficientsArray[i].name): \t\(thermalCoefficientsArray[i].valueText)\n"
            }
        }
        return result
    }
}
