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

    init(typeOfAnalysis: TypeOfAnalysis, dataJSON: JSON) {
        effectiveSolidStiffness = dataJSON["solidModelResult"]["effectiveSolidStiffness"].dictionaryObject
        engineeringConstants = dataJSON["solidModelResult"]["engineeringConstants"].dictionaryObject
        if typeOfAnalysis == .thermoElastic {
            thermalCoefficients = dataJSON["solidModelResult"]["thermalCoefficients"].dictionaryObject
        }
    }
}
