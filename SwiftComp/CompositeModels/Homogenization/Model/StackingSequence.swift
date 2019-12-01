//
//  StackingSequence.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/23/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class StackingSequence {
    var sectionTitle: String = "Stacking Sequence"
    
    var stackingSequenceText: String {
        didSet {
            stackingSequence = parseStackingSequenceText(stackingSequenceText: stackingSequenceText)
        }
    }
    var stackingSequence: [Double]?
    var stackingSequenceAPI: String {
        return stackingSequence?.map{String($0)}.joined(separator: " ") ?? ""
    }
    
    var rBefore: Int = 1
    var rAfter: Int = 1
    var symmetry: Bool = false
    
    var layerThickness: Double?
    var layerThicknessText: String {
        didSet {
            layerThickness = Double(layerThicknessText)
        }
    }
    
    init(stackingSequenceText: String, layerThickness: Double) {
        self.stackingSequenceText = stackingSequenceText
        self.layerThickness = layerThickness
        layerThicknessText = "\(layerThickness)"
        stackingSequence = parseStackingSequenceText(stackingSequenceText: stackingSequenceText)
    }
    
    init(sectionTitle: String, stackingSequenceText: String, layerThickness: Double) {
        self.sectionTitle = sectionTitle
        self.stackingSequenceText = stackingSequenceText
        self.layerThickness = layerThickness
        layerThicknessText = "\(layerThickness)"
        stackingSequence = parseStackingSequenceText(stackingSequenceText: stackingSequenceText)
    }
    
    func parseStackingSequenceText(stackingSequenceText: String) -> [Double]? {
        var baseLayup: String
        var baseLayupSequence = [Double]()
        var layupSequence = [Double]()
        var numberOfLayers: Int = 0

        guard stackingSequenceText != "" else { return nil }

        let str = stackingSequenceText

        if str.split(separator: "]").count == 2 {
            baseLayup = str.split(separator: "]")[0].replacingOccurrences(of: "[", with: "")
            let rsr = str.split(separator: "]")[1]
            if rsr.split(separator: "s").count == 2 {
                symmetry = true
                if let i = Int(rsr.split(separator: "s")[0]), let j = Int(rsr.split(separator: "s")[1]) {
                    rBefore = i
                    rAfter = j
                } else {
                    return nil
                }
            } else if rsr.contains("s") {
                symmetry = true
                if (rsr[rsr.startIndex] == "s") && (rsr == "s") {
                    rAfter = 1
                    rBefore = 1
                } else if rsr[rsr.startIndex] == "s" {
                    rBefore = 1
                    if rsr.split(separator: "s") != [] {
                        if let i = Int(rsr.split(separator: "s")[0]) {
                            rAfter = i
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    rAfter = 1
                    if let i = Int(rsr.split(separator: "s")[0]) {
                        rBefore = i
                    } else {
                        return nil
                    }
                }
            } else {
                symmetry = false
                rBefore = 1
                if let i = Int(rsr) {
                    rAfter = i
                } else {
                    return nil
                }
            }
        } else {
            baseLayup = str.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
            rBefore = 1
            rAfter = 1
            symmetry = false
        }

        for i in baseLayup.components(separatedBy: "/") {
            if let j = Double(i) {
                baseLayupSequence.append(j)
            } else {
                return nil
            }
        }

        numberOfLayers = symmetry ?
            baseLayupSequence.count * rBefore * 2 * rAfter :
            baseLayupSequence.count * rBefore * rAfter
        
        guard numberOfLayers > 0 && numberOfLayers < 1_000_000 else { return nil }
        for _ in 1 ... rBefore {
            for i in baseLayupSequence {
                layupSequence.append(i)
            }
        }

        baseLayupSequence = layupSequence

        if symmetry {
            for i in baseLayupSequence.reversed() {
                layupSequence.append(i)
            }
        }

        baseLayupSequence = layupSequence

        if rAfter > 1 {
            for _ in 2 ... rAfter {
                for i in baseLayupSequence {
                    layupSequence.append(i)
                }
            }
        }

        return layupSequence
    }
}
