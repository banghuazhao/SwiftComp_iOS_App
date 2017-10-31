//
//  MaterialTypeModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/30/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import Foundation


struct MaterialPropertyName {
    let isotropic =  ["Young's Modulus E", "Poisson's Ratio ν", "CTE α"]
    let transverseIsotropic = ["Young's Modulus E1", "Young's Modulus E2", "Shear Modulus G12", "Poisson's Ratio ν12", "Poisson's Ratio ν23", "CTE α11", "CTE α22"]
    let orthotropic = ["Young's Modulus E1", "Young's Modulus E2", "Young's Modulus E3", "Shear Modulus G12", "Shear Modulus G13", "Shear Modulus G23", "Poisson's Ratio ν12", "Poisson's Ratio ν13", "Poisson's Ratio ν23", "CTE α11" , "CTE α22", "CTE α33"]
}

struct MaterialPropertyLabel {
    let isotropic = ["E1", "ν12", "α11"]
    let transverseIsotropic = ["E1", "E2", "G12", "ν12", "ν23", "α11", "α22"]
    let orthotropic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23", "α11", "α22", "α33"]
}

struct MaterialPropertyPlaceHolder {
    let isotropic = ["E", "ν", "α"]
    let transverseIsotropic = ["E1", "E2", "G12", "ν12", "ν23", "α11", "α22"]
    let orthotropic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23", "α11", "α22", "α33"]
}
