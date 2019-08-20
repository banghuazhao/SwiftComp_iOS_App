//
//  MaterialTypeModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/30/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import Foundation

enum typeOfAnalysis {
    case elastic
    case thermalElatic
}

enum structuralModel {
    case beam
    case plate
    case solid
}

enum materialType {
    case isotropic
    case transverselyIsotropic
    case inPlateMonoclinic
    case orthotropic
    case monoclinic
    case anisotropic
}


struct MaterialPropertyLabel {
    let isotropic =  ["Young's Modulus E", "Poisson's Ratio ν"]
    let isotropicThermal = ["CTE α"]
    
    let transverselyIsotropic = ["Young's Modulus E1", "Young's Modulus E2", "Shear Modulus G12", "Poisson's Ratio ν12", "Poisson's Ratio ν23"]
    let transverselyIsotropicThermal = ["CTE α11", "CTE α22"]
    
    let inPlateMonoclinic = ["Young's Modulus E1", "Young's Modulus E2", "Shear Modulus G12", "Poisson's Ratio ν12", "Mutual Influence η12,1", "Mutual Influence η12,2"]
    
    let orthotropic = ["Young's Modulus E1", "Young's Modulus E2", "Young's Modulus E3", "Shear Modulus G12", "Shear Modulus G13", "Shear Modulus G23", "Poisson's Ratio ν12", "Poisson's Ratio ν13", "Poisson's Ratio ν23"]
    let orthotropicThermal = ["CTE α11", "CTE α22", "CTE α33"]
    
    let monoclinic = ["Young's Modulus E1", "Young's Modulus E2", "Young's Modulus E3", "Shear Modulus G12", "Shear Modulus G13", "Shear Modulus G23", "Poisson's Ratio ν12", "Poisson's Ratio ν13", "Poisson's Ratio ν23", "Mutual Influence η12,1", "Mutual Influence η12,2", "Mutual Influence η12,3", "Mutual Influence η13,23"]
    let monoclinicThermal = ["CTE α11" , "CTE α22", "CTE α33", "CTE α12"]
    
    let anisotropic = ["Material Constant C11", "Material Constant C12", "Material Constant C13", "Material Constant C14", "Material Constant C15", "Material Constant C16", "Material Constant C22", "Material Constant C23", "Material Constant C24", "Material Constant C25", "Material Constant C26", "Material Constant C33", "Material Constant C34", "Material Constant C35", "Material Constant C36", "Material Constant C44", "Material Constant C45", "Material Constant C46", "Material Constant C55", "Material Constant C56", "Material Constant C66"]
    let anisotropicThermal = ["CTE α11" , "CTE α22", "CTE α33", "CTE 2α23" , "CTE 2α13", "CTE 2α12"]
    
}

struct MaterialPropertyName {
    let isotropic = ["E", "ν"]
    let isotropicThermal = ["α"]
    
    let transverselyIsotropic = ["E1 (transversely)", "E2 (transversely)", "G12 (transversely)", "ν12 (transversely)", "ν23 (transversely)"]
    let transverselyIsotropicThermal = ["α11 (transversely)", "α22 (transversely)"]
    
    let orthotropic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23"]
    let orthotropicThermal = ["α11", "α22", "α33"]
    
    let monoclinic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23", "η12,1", "η12,2", "η12,3", "η13,23"]
    let monoclinicThermal = ["α11" , "α22", "α33", "α12"]
    
    let anisotropic = ["C11", "C12", "C13", "C14", "C15", "C16", "C22", "C23", "C24", "C25", "C26", "C33", "C34", "C35", "C36", "C44", "C45", "C46", "C55", "C56", "C66"]
    let anisotropicThermal = ["α11 (anisotropic)" , "α22 (anisotropic)", "α33 (anisotropic)", "2α23 (anisotropic)", "2α13 (anisotropic)", "2α12 (anisotropic)"]
}

struct MaterialPropertyPlaceHolder {
    let isotropic = ["E", "ν"]
    let isotropicThermal = ["α"]
    
    let transverselyIsotropic = ["E1", "E2", "G12", "ν12", "ν23"]
    let transverselyIsotropicThermal = ["α11", "α22"]
    
    let orthotropic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23"]
    let orthotropicThermal = ["α11", "α22", "α33"]
    
    let monoclinic = ["E1", "E2", "E3", "G12", "G13", "G23", "ν12", "ν13", "ν23", "η12,1", "η12,2", "η12,3", "η13,23"]
    let monoclinicThermal = ["α11" , "α22", "α33", "α12"]
    
    let anisotropic = ["C11", "C12", "C13", "C14", "C15", "C16", "C22", "C23", "C24", "C25", "C26", "C33", "C34", "C35", "C36", "C44", "C45", "C46", "C55", "C56", "C66"]
    let anisotropicThermal = ["α11" , "α22", "α33", "2α23", "2α13", "2α12"]
}
