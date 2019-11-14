//
//  AnalysisSettingsModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

enum CompositeModelName {
    case Laminate
    case UDFRC
    case HoneycombSandwich
}

enum CalculationMethod {
    case SwiftComp
    case NonSwiftComp
}

enum StructuralModel {
    case beam
    case plate
    case solid
}

enum StructuralSubmodel {
    case CauchyContinuumModel
    case EulerBernoulliBeamModel
    case TimoshenkoBeamModel
    case KirchhoffLovePlateShellModel
    case ReissnerMindlinPlateShellModel
}

enum TypeOfAnalysis {
    case elastic
    case thermoElastic
}

class AnalysisSettings {
    var compositeModelName : CompositeModelName
    var calculationMethod: CalculationMethod
    var structuralModel : StructuralModel
    var structuralSubmodel: StructuralSubmodel
    var typeOfAnalysis : TypeOfAnalysis
    
    
    init(compositeModelName: CompositeModelName, calculationMethod: CalculationMethod, typeOfAnalysis: TypeOfAnalysis, structuralModel : StructuralModel, structuralSubmodel: StructuralSubmodel) {
        self.compositeModelName = compositeModelName
        self.calculationMethod = calculationMethod
        self.structuralModel = structuralModel
        self.structuralSubmodel = structuralSubmodel
        self.typeOfAnalysis = typeOfAnalysis
    }
}
