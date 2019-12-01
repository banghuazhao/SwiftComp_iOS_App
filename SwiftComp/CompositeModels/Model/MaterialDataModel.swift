//
//  MaterialDataModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import Foundation

class MaterialOld {
    
    let materialName : String
    let materialType : MaterialType
    let materialProperties : [String : Double]
    
    init(name : String, type : MaterialType, properties: [String : Double]) {
        self.materialName = name
        self.materialProperties = properties
        self.materialType = type
    }
    
}

class MaterialBank {
    
    var list = [MaterialOld]()
    
    init() {
        list.append(MaterialOld(name: "E-Glass", type: .isotropic, properties: ["E": 77.0, "ν" : 0.22, "α" : 5.4]))
        
        list.append(MaterialOld(name: "S-Glass", type: .isotropic, properties: ["E": 85.0, "ν" : 0.23, "α" : 1.6]))
        
        list.append(MaterialOld(name: "Carbon (IM)", type: .isotropic, properties: ["E": 230.0, "ν" : 0.20, "α" : -0.3]))
        
        list.append(MaterialOld(name: "Carbon (HM)", type: .isotropic, properties: ["E": 350.0, "ν" : 0.20, "α" : -0.8]))
        
        list.append(MaterialOld(name: "Boron", type: .isotropic, properties: ["E": 385.0, "ν" : 0.22, "α" : 5.4]))
        
        list.append(MaterialOld(name: "Kelvar-49", type: .isotropic, properties: ["E": 130.0, "ν" : 0.34, "α" : -2.0]))
        
        list.append(MaterialOld(name: "Epoxy", type: .isotropic, properties: ["E": 4.6, "ν" : 0.36, "α" : 63]))
        
        list.append(MaterialOld(name: "Polyester", type: .isotropic, properties: ["E": 2.8, "ν" : 0.30, "α" : 130]))
        
        list.append(MaterialOld(name: "Polyimide", type: .isotropic, properties: ["E": 3.5, "ν" : 0.35, "α" : 36]))
        
        list.append(MaterialOld(name: "PEEK", type: .isotropic, properties: ["E": 400, "ν" : 0.25, "α" : 78]))
        
        list.append(MaterialOld(name: "Copper", type: .isotropic, properties: ["E": 117, "ν" : 0.33, "α" : 17]))
        
        list.append(MaterialOld(name: "Silicon Carbide", type: .isotropic, properties: ["E": 400, "ν" : 0.25, "α" : 4.8]))
        
        list.append(MaterialOld(name: "IM7/8552", type: .orthotropic, properties: ["E1" : 161.0, "E2" : 11.38, "E3" : 11.38, "G12" : 5.17, "G13" : 5.17, "G23" : 3.98, "ν12" : 0.32, "ν13" : 0.32, "ν23" : 0.44, "α11" : 10, "α22" : 20, "α33" : 20]))
        
        list.append(MaterialOld(name: "T2C190/F155", type: .orthotropic, properties: ["E1" : 122.7, "E2" : 8.69, "E3" : 8.69, "G12" : 5.9, "G13" : 5.9, "G23" : 3.3, "ν12" : 0.340, "ν13" : 0.340, "ν23" : 0.400, "α11" : 10, "α22" : 20, "α33" : 20]))
        
        list.append(MaterialOld(name: "Nomex", type: .isotropic, properties: ["E": 3.0, "ν" : 0.3, "α" : 20]))
        list.append(MaterialOld(name: "Aluminum", type: .isotropic, properties: ["E": 68.0, "ν" : 0.36, "α" : 8.1]))
        list.append(MaterialOld(name: "Steel", type: .isotropic, properties: ["E": 200.0, "ν" : 0.25, "α" : 11.5]))
        
    }
    
    
}
