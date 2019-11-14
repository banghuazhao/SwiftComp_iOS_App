//
//  ResultTypeModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

enum ResultCardType {
    case generalThreeByThreeMatrix
    case generalTwoByTwoMatrix
    case beamFourByFourStiffnessMatrix
    case solidSixBySixStiffnessMatrixTwoColumn
    case engineeringConstantsOrthotropic
    case inPlateProperties
    case thermalCoefficients
}

struct ResultCardLabel {
    
    let effectiveSolidStiffnessMatrixLabel = ["C11", "C12", "C13", "C14" ,"C15", "C16", "C22", "C23", "C24", "C25", "C26", "C33", "C34", "C35", "C36", "C44", "C45", "C46", "C55", "C56", "C66"]
    
    let engineeringConstantsOrthotropicLabel = ["Young's Modulus E1", "Young's Modulus E2", "Young's Modulus E3", "Shear Modulus G12", "Shear Modulus G13", "Shear Modulus G23", "Poisson's Ratio ν12", "Poisson's Ratio ν13", "Poisson's Ratio ν23"]
    
    let inPlatePropertiesLabel = ["Young's Modulus E1", "Young's Modulus E2", "Shear Modulus G12", "Poisson's Ratio ν12", "Mutual Influence η12,1", "Mutual Influence η12,2"]
    
    let thermalCoefficientsLabel = ["CTE α11" , "CTE α22", "CTE α33", "CTE 2α23" , "CTE 2α13", "CTE 2α12"]
}
