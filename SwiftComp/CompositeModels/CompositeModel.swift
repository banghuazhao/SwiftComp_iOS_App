//
//  CompositeModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/22/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class CompositeModel {
    let name: String
    let subname: String
    let image: UIImage
    
    enum StructrualModel {
        case beam
        case plate
        case solid
    }
    let structrualModels: [StructrualModel]

    init(name: String, subname: String, image: UIImage, structrualModels: [StructrualModel]) {
        self.name = name
        self.subname = subname
        self.image = image
        self.structrualModels = structrualModels
    }
}

class CompoisteModels {
    var SG1D: [CompositeModel]
    var SG2D: [CompositeModel]
    var SG3D: [CompositeModel]

    init() {
        let laminate = CompositeModel(name: "Laminate", subname: "1D SG of laminate", image: #imageLiteral(resourceName: "laminate"), structrualModels: [.plate, .solid])
        let UDFRC = CompositeModel(name: "Unidirectional Fiber Reinforced Composite (UDFRC)", subname: "2D SG of square pack microstructure", image: #imageLiteral(resourceName: "spuarePack"), structrualModels: [.beam, .plate, .solid])
        let honeycombSandwich = CompositeModel(name: "Honeycomb Sandwich Structure", subname: "3D SG of honeycomb sandwich", image: #imageLiteral(resourceName: "honeycomb_sandwich"), structrualModels: [.beam, .plate])
        let experiment = CompositeModel(name: "Experiment", subname: "3D SG of experiment", image: #imageLiteral(resourceName: "honeycomb_sandwich"), structrualModels: [.beam, .plate, .solid])

        SG1D = [laminate]
        SG2D = [UDFRC]
        SG3D = [honeycombSandwich, experiment]
    }
}
