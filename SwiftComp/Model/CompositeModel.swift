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
    
    init(name: String, subname: String, image: UIImage) {
        self.name = name
        self.subname = subname
        self.image = image
    }
    
}


class CompoisteModels {
    
    var SG1D: [CompositeModel]
    var SG2D: [CompositeModel]
    var SG3D: [CompositeModel]
    
    init() {
        let laminate = CompositeModel(name: "Laminate",subname: "1D SG of laminate", image: #imageLiteral(resourceName: "laminate"))
        let UDFRC = CompositeModel(name: "Unidirectional Fiber Reinforced Composite (UDFRC)", subname: "2D SG of square pack microstructure", image: #imageLiteral(resourceName: "spuarePack"))
        let honeycombSandwich = CompositeModel(name: "Honeycomb Sandwich Structure", subname: "3D SG of honeycomb sandwich", image: #imageLiteral(resourceName: "honeycomb_sandwich"))
        
        self.SG1D = [laminate]
        self.SG2D = [UDFRC]
        self.SG3D = [honeycombSandwich]
    }
}
