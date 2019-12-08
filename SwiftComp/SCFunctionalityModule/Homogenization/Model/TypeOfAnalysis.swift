//
//  TypeOfAnalysis.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/23/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

enum TypeOfAnalysis {
    case elastic
    case thermoElastic
    
    var typeOfAnalysisAPI: String {
        switch self {
        case .elastic:
            return "Elastic"
        case .thermoElastic:
            return "Thermoelastic"
        }
    }
}
