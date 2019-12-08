//
//  Constant.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

struct Constant {
    static let appID = "1297825946"

    static let baseURL = "http://128.46.6.100:8888"

    static let isIPhone : Bool = UIDevice.current.userInterfaceIdiom == .phone

    static let isIPad : Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    struct MethodName {
        static let swiftComp = "SwiftComp"
        struct NonSwiftComp {
            static let clpt = "Classical Laminated Plate Theory"
            static let voigtROM = "Voigt Rules of Mixture"
            static let reussROM = "Reuss Rules of Mixture"
            static let hybridROM = "Hybrid Rules of Mixture"
        }
    }
    
    struct ModelName {
        static let beam = "Beam Model"
        static let plate = "Plate/Shell Model"
        static let solid = "Solid Model"
    }
    
    struct SubmodelName {
        struct Beam {
            static let eulerBernoulli = "Euler Bernoulli Model"
            static let timoshenko = "Timoshenko Model"
        }
        struct Plate {
            static let kirchhoffLove = "Kirchhoff Love Model"
            static let reissnerMindlin = "Reissner Mindlin Model"
        }
        struct Solid {
            static let cauchyContinuum = "Cauchy Continuum Model"
        }
    }
    
    struct TypeOfAnalysisName {
        static let elastic = "Elastic Analysis"
        static let thermoElastic = "Thermoelastic Analysis"
    }
}


