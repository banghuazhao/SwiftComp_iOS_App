//
//  HomSolidResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomSolidResult {
    var effectiveSolidStiffness: [String: Any]?
    var engineeringConstants: [String: Any]?
    var thermalCoefficients: [String: Any]?
    
    var effectiveSolidStiffnessArray: [HomResultMatrix] = []
    var engineeringConstantsArray: [HomResultProperty] = []
    var thermalCoefficientsArray: [HomResultProperty] = []

    init(typeOfAnalysis: TypeOfAnalysis, dataJSON: JSON) {
        effectiveSolidStiffness = dataJSON["solidModelResult"]["effectiveSolidStiffness"].dictionaryObject
        engineeringConstants = dataJSON["solidModelResult"]["engineeringConstants"].dictionaryObject
        
        setEffectiveSolidStiffness()
        setEngineeringConstantsArray()
        if typeOfAnalysis == .thermoElastic {
            thermalCoefficients = dataJSON["solidModelResult"]["thermalCoefficients"].dictionaryObject
            setThermalCoefficientsArray()
        }
    }
    
    init(typeOfAnalysis: TypeOfAnalysis, effectiveSolidStiffness: [String: String], engineeringConstants: [String: String], thermalCoefficients: [String: String]?) {
        self.effectiveSolidStiffness = effectiveSolidStiffness
        self.engineeringConstants = engineeringConstants
        setEffectiveSolidStiffness()
        setEngineeringConstantsArray()
        if typeOfAnalysis == .thermoElastic {
            self.thermalCoefficients = thermalCoefficients
            setThermalCoefficientsArray()
        }
    }
    
    private func setEffectiveSolidStiffness() {
        guard let effectiveSolidStiffness = effectiveSolidStiffness as? [String: String] else { return }
        effectiveSolidStiffnessArray = [
            HomResultMatrix(valueText: effectiveSolidStiffness["C11"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C12"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C13"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C14"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C15"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C16"] ?? ""),
            
            HomResultMatrix(valueText: effectiveSolidStiffness["C12"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C22"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C23"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C24"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C25"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C26"] ?? ""),
            
            HomResultMatrix(valueText: effectiveSolidStiffness["C13"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C23"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C33"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C34"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C35"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C36"] ?? ""),
            
            HomResultMatrix(valueText: effectiveSolidStiffness["C14"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C24"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C34"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C44"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C45"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C46"] ?? ""),
            
            HomResultMatrix(valueText: effectiveSolidStiffness["C15"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C25"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C35"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C45"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C55"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C56"] ?? ""),
            
            HomResultMatrix(valueText: effectiveSolidStiffness["C16"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C26"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C36"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C46"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C56"] ?? ""),
            HomResultMatrix(valueText: effectiveSolidStiffness["C66"] ?? ""),
        ]
    }
    
    private func setEngineeringConstantsArray() {
        guard let engineeringConstants = engineeringConstants as? [String: String] else { return }
        engineeringConstantsArray = [
            HomResultProperty(name: "Young's Modulus E₁",  valueText: engineeringConstants["E1"] ?? ""),
            HomResultProperty(name: "Young's Modulus E₂",  valueText: engineeringConstants["E2"] ?? ""),
            HomResultProperty(name: "Young's Modulus E₃",  valueText: engineeringConstants["E3"] ?? ""),
            HomResultProperty(name: "Shear Modulus G₁₂",   valueText: engineeringConstants["G12"] ?? ""),
            HomResultProperty(name: "Shear Modulus G₁₃",   valueText: engineeringConstants["G13"] ?? ""),
            HomResultProperty(name: "Shear Modulus G₂₃",   valueText: engineeringConstants["G23"] ?? ""),
            HomResultProperty(name: "Poisson's Ratio ν₁₂", valueText: engineeringConstants["nu12"] ?? ""),
            HomResultProperty(name: "Poisson's Ratio ν₁₃", valueText: engineeringConstants["nu13"] ?? ""),
            HomResultProperty(name: "Poisson's Ratio ν₂₃", valueText: engineeringConstants["nu23"] ?? "")
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
            HomResultProperty(name: "CTE α₁₂", valueText: thermalCoefficients["alpha12"] ?? "")
        ]
    }
}

// MARK: - public function

extension HomSolidResult {
    func getSharedResultText() -> String {
        var result = ""
        if effectiveSolidStiffness != nil {
            for i in 0...5 {
                result += effectiveSolidStiffnessArray[i * 6].valueText + "\t" +
                    effectiveSolidStiffnessArray[i * 6 + 1].valueText + "\t" +
                    effectiveSolidStiffnessArray[i * 6 + 2].valueText + "\t" +
                    effectiveSolidStiffnessArray[i * 6 + 3].valueText + "\t" +
                    effectiveSolidStiffnessArray[i * 6 + 4].valueText + "\t" +
                    effectiveSolidStiffnessArray[i * 6 + 5].valueText + "\n"
            }
        }
        
        if engineeringConstants != nil {
            result += "\n"
            result += "Engineering Constants:\n"
            for i in 0...engineeringConstantsArray.count-1 {
                result += "\(engineeringConstantsArray[i].name): \t\(engineeringConstantsArray[i].valueText)\n"
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
