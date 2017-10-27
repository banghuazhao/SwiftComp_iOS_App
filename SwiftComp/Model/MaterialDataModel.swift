//
//  MaterialDataModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import Foundation

class Material {
    
    let materialName : String
    let materialProperties : [String : Double]
    
    init(name : String, properties: [String : Double]) {
        self.materialName = name
        self.materialProperties = properties
    }
    
}

class MaterialBank {
    
    var list = [Material]()
    
    init() {
        list.append(Material(name: "E-Glass",     properties: ["E1" : 77.0, "E2" : 77.0, "G12" : 77.0/(2*(1+0.22)), "v12" : 0.22, "v23" : 0.22]))
        list.append(Material(name: "S-Glass",     properties: ["E1" : 85.0, "E2" : 85.0, "G12" : 85.0/(2*(1+0.23)), "v12" : 0.23, "v23" : 0.23]))
        list.append(Material(name: "Carbon (IM)", properties: ["E1" : 230.0, "E2" : 230.0, "G12" : 230.0/(2*(1+0.20)),  "v12" : 0.20, "v23" : 0.20]))
        list.append(Material(name: "Carbon (HM)", properties: ["E1" : 350.0, "E2" : 350.0, "G12" : 350.0/(2*(1+0.20)),  "v12" : 0.20, "v23" : 0.20]))
        list.append(Material(name: "Boron",       properties: ["E1" : 385.0, "E2" : 385.0, "G12" : 385.0/(2*(1+0.21)),  "v12" : 0.21, "v23" : 0.21]))
        list.append(Material(name: "Kelvar-49",   properties: ["E1" : 130.0, "E2" : 130.0, "G12" : 130.0/(2*(1+0.34)),  "v12" : 0.34, "v23" : 0.34]))
        list.append(Material(name: "Epoxy",       properties: ["E1" : 4.6, "E2" : 4.6, "G12" : 4.6/(2*(1+0.36)),  "v12" : 0.36, "v23" : 0.36]))
        list.append(Material(name: "Polyester",   properties: ["E1" : 2.8, "E2" : 2.8, "G12" : 2.8/(2*(1+0.30)),  "v12" : 0.30, "v23" : 0.30]))
        list.append(Material(name: "Polyimide",   properties: ["E1" : 3.5, "E2" : 3.5, "G12" : 3.5/(2*(1+0.35)),  "v12" : 0.35, "v23" : 0.35]))
        list.append(Material(name: "PEEK",   properties: ["E1" : 400, "E2" : 400, "G12" : 400/(2*(1+0.25)),  "v12" : 0.25, "v23" : 0.25]))
        list.append(Material(name: "Copper",      properties: ["E1" : 117, "E2" : 117, "G12" : 117/(2*(1+0.33)),  "v12" : 0.33, "v23" : 0.33]))
        list.append(Material(name: "Kelvar-49",   properties: ["E1" : 130, "E2" : 130, "G12" : 130/(2*(1+0.34)),  "v12" : 0.34, "v23" : 0.34]))
        list.append(Material(name: "Silicon Carbide",   properties: ["E1" : 400, "E2" : 400, "G12" : 400/(2*(1+0.25)),  "v12" : 0.25, "v23" : 0.25]))
        list.append(Material(name: "IM7/8552", properties: ["E1" : 161.3, "E2" : 11.38, "E3" : 11.38, "G12" : 5.2, "G13" : 5.2, "G23" : 3.9, "v12" : 0.320, "v13" : 0.320, "v23" : 0.450]))
        list.append(Material(name: "T2C190/F155", properties: ["E1" : 122.7, "E2" : 8.69, "E3" : 8.69, "G12" : 5.9, "G13" : 5.9, "G23" : 3.3, "v12" : 0.340, "v13" : 0.340, "v23" : 0.400]))
    }
    
    
}
