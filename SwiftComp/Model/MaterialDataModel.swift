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
        list.append(Material(name: "E-Glass",     properties: ["E1" : 77.0, "E2" : 77.0, "G12" : 77.0/(2*(1+0.22)), "ν12" : 0.22, "ν23" : 0.22, "α11" : 5.4, "α22" : 5.4]))
        
        list.append(Material(name: "S-Glass",     properties: ["E1" : 85.0, "E2" : 85.0, "G12" : 85.0/(2*(1+0.23)), "ν12" : 0.23, "ν23" : 0.23, "α11" : 1.6, "α22" : 1.6]))
        
        list.append(Material(name: "Carbon (IM)", properties: ["E1" : 230.0, "E2" : 230.0, "G12" : 230.0/(2*(1+0.20)),  "ν12" : 0.20, "ν23" : 0.20, "α11" : -0.3, "α22" : -0.8]))
        
        list.append(Material(name: "Carbon (HM)", properties: ["E1" : 350.0, "E2" : 350.0, "G12" : 350.0/(2*(1+0.20)),  "ν12" : 0.20, "ν23" : 0.20, "α11" : -0.8, "α22" : -0.8]))
        
        list.append(Material(name: "Boron",       properties: ["E1" : 385.0, "E2" : 385.0, "G12" : 385.0/(2*(1+0.21)),  "ν12" : 0.21, "ν23" : 0.21, "α11" : 8.3, "α22" : 8.3]))
        
        list.append(Material(name: "Kelvar-49",   properties: ["E1" : 130.0, "E2" : 130.0, "G12" : 130.0/(2*(1+0.34)),  "ν12" : 0.34, "ν23" : 0.34, "α11" : -2.0, "α22" : -2.0]))
        
        list.append(Material(name: "Epoxy",       properties: ["E1" : 4.6, "E2" : 4.6, "G12" : 4.6/(2*(1+0.36)),  "ν12" : 0.36, "ν23" : 0.36, "α11" : 63, "α22" : 63]))
        
        list.append(Material(name: "Polyester",   properties: ["E1" : 2.8, "E2" : 2.8, "G12" : 2.8/(2*(1+0.30)),  "ν12" : 0.30, "ν23" : 0.30, "α11" : 130, "α22" : 130]))
        
        list.append(Material(name: "Polyimide",   properties: ["E1" : 3.5, "E2" : 3.5, "G12" : 3.5/(2*(1+0.35)),  "ν12" : 0.35, "ν23" : 0.35, "α11" : 36, "α22" : 36]))
        
        list.append(Material(name: "PEEK",   properties: ["E1" : 400, "E2" : 400, "G12" : 400/(2*(1+0.25)),  "ν12" : 0.25, "ν23" : 0.25, "α11" : 78, "α22" : 78]))
        
        list.append(Material(name: "Copper",      properties: ["E1" : 117, "E2" : 117, "G12" : 117/(2*(1+0.33)),  "ν12" : 0.33, "ν23" : 0.33, "α11" : 17, "α22" : 17]))
        
        list.append(Material(name: "Silicon Carbide",   properties: ["E1" : 400, "E2" : 400, "G12" : 400/(2*(1+0.25)),  "ν12" : 0.25, "ν23" : 0.25, "α11" : 4.8, "α22" : 4.8]))
        
        list.append(Material(name: "IM7/8552", properties: ["E1" : 161.0, "E2" : 11.38, "E3" : 11.38, "G12" : 5.17, "G13" : 5.17, "G23" : 3.98, "ν12" : 0.32, "ν13" : 0.32, "ν23" : 0.44, "α11" : 10, "α22" : 20, "α33" : 20]))
        
        list.append(Material(name: "T2C190/F155", properties: ["E1" : 122.7, "E2" : 8.69, "E3" : 8.69, "G12" : 5.9, "G13" : 5.9, "G23" : 3.3, "ν12" : 0.340, "ν13" : 0.340, "ν23" : 0.400, "α11" : 10, "α22" : 20, "α33" : 20]))
        
    }
    
    
}
