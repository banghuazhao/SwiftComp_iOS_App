//
//  HomInformation.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Array where Array.Element == String {
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> String? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

class HomInformation {
    var route: String
    var swiftcompCalculationInfo: String
    var swiftcompCwd: String
    var calculationTime: Double
    var calculationTimeText: String

    init(route: String, dataJSON: JSON) {
        self.route = route
        swiftcompCalculationInfo = dataJSON["swiftcompCalculationInfo"].description
        swiftcompCwd = dataJSON["swiftcompCwd"].description
        let infoArray: [String] = swiftcompCalculationInfo.split(separator: " ").map { String($0) }
        let startTimeIndex = (infoArray.firstIndex(of: "begins") ?? 0) + 2
        let startTime = Double(infoArray.get(index: startTimeIndex) ?? "0.0") ?? 0.0
        let endTimeIndex = (infoArray.firstIndex(of: "ends") ?? 0) + 2
        let endTime = Double(infoArray.get(index: endTimeIndex) ?? "0.0") ?? 0.0
        calculationTime = endTime - startTime
        if abs(calculationTime) < 1e-3 {
            calculationTimeText = String(format: "%.3e", calculationTime)
        } else if calculationTime == 0.0 {
            calculationTimeText = "0.0"
        } else {
            calculationTimeText = String(format: "%.4f", calculationTime)
        }
    }
}
