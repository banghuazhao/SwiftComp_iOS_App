//
//  StructuralModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/23/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class StructuralModel {
    enum Model: Equatable {
        case beam(Beam)
        case plate(Plate)
        case solid(Solid)
        enum Beam {
            case eulerBernoulli
            case timoshenko
        }

        enum Plate {
            case kirchhoffLove
            case reissnerMindlin
        }

        enum Solid {
            case cauchyContinuum
        }
    }
    
    var structrualModelAPI: String {
        switch model {
        case .beam(_):
            return "Beam"
        case .plate(_):
            return "Plate"
        case .solid(_):
            return "Solid"
        }
    }
    
    var structrualSubmodelAPI: String {
        switch model {
        case .beam(.eulerBernoulli):
            return "EulerBernoulliBeamModel"
        case .beam(.timoshenko):
            return "TimoshenkoBeamModel"
        case .plate(.kirchhoffLove):
           return "KirchhoffLovePlateShellModel"
        case .plate(.reissnerMindlin):
            return "ReissnerMindlinPlateShellModel"
        case .solid(.cauchyContinuum):
           return "CauchyContinuumModel"
        }
    }
    
    struct PlateExtraInput {
        var k12: Double? = 0.0
        var k21: Double? = 0.0
        var k12Text: String = "0.0" {
            didSet {
                k12 = Double(k12Text)
            }
        }
        var k21Text: String = "0.0" {
            didSet {
                k21 = Double(k21Text)
            }
        }
    }

    struct BeamExtraInput {
        var k11: Double? = 0.0
        var k12: Double? = 0.0
        var k13: Double? = 0.0
        var cosAngle1: Double? = 1.0
        var cosAngle2: Double? = 0.0
        var k11Text: String = "0.0" {
            didSet {
                k11 = Double(k11Text)
            }
        }
        var k12Text: String = "0.0" {
            didSet {
                k12 = Double(k12Text)
            }
        }
        var k13Text: String = "0.0" {
            didSet {
                k13 = Double(k13Text)
            }
        }
        var cosAngle1Text: String = "1.0" {
            didSet {
                cosAngle1 = Double(cosAngle1Text)
            }
        }
        var cosAngle2Text: String = "0.0" {
            didSet {
                cosAngle2 = Double(cosAngle2Text)
            }
        }
    }
    
    var model: Model
    var plateExtraInput: PlateExtraInput
    var beamExtraInput: BeamExtraInput
    
    init(model: Model ) {
        self.model = model
        self.plateExtraInput = PlateExtraInput()
        self.beamExtraInput = BeamExtraInput()
    }
    
}
