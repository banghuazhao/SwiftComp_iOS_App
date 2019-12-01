//
//  Material.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/24/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation

class Material {
    var name: String

    enum MaterialType: Equatable {
        case isotropic(TypeOfAnalysis)
        case transverselyIsotropic(TypeOfAnalysis)
        case orthotropic(TypeOfAnalysis)
        case monoclinic(TypeOfAnalysis)
        case anisotropic(TypeOfAnalysis)
    }

    var materialProperties: [MaterialProperty]
    var materialType: MaterialType
    var analysisType: TypeOfAnalysis {
        get {
            switch materialType {
            case .isotropic(.elastic), .transverselyIsotropic(.elastic), .orthotropic(.elastic), .monoclinic(.elastic), .anisotropic(.elastic):
                return .elastic
            case .isotropic(.thermoElastic), .transverselyIsotropic(.thermoElastic), .orthotropic(.thermoElastic), .monoclinic(.thermoElastic), .anisotropic(.thermoElastic):
                return .thermoElastic
            }
        }
        set {
            switch materialType {
            case .isotropic:
                materialType = .isotropic(newValue)
            case .transverselyIsotropic:
                materialType = .transverselyIsotropic(newValue)
            case .orthotropic:
                materialType = .orthotropic(newValue)
            case .monoclinic:
                materialType = .monoclinic(newValue)
            case .anisotropic:
                materialType = .anisotropic(newValue)
            }
        }
    }

    init(name: String, materialType: MaterialType) {
        self.name = name
        self.materialType = materialType
        self.materialProperties = []
        initMaterialProperties()
    }

    init(name: String, materialType: MaterialType, materialProperties: [MaterialProperty]) {
        self.name = name
        self.materialType = materialType
        self.materialProperties = materialProperties
    }
}

// MARK: - private functions

extension Material {
    // MARK: - initMaterialProperties

    private func initMaterialProperties() {
        switch materialType {
        case .isotropic(.elastic):
            materialProperties = [
                MaterialProperty(name: .E),
                MaterialProperty(name: .nu),
            ]
        case .isotropic(.thermoElastic):
            materialProperties = [
                MaterialProperty(name: .E),
                MaterialProperty(name: .nu),
                MaterialProperty(name: .alpha),
            ]
        case .transverselyIsotropic(.elastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu23),
            ]
        case .transverselyIsotropic(.thermoElastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu23),
                MaterialProperty(name: .alpha11),
                MaterialProperty(name: .alpha22),
            ]
        case .orthotropic(.elastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .E3),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .G13),
                MaterialProperty(name: .G23),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu13),
                MaterialProperty(name: .nu23),
            ]
        case .orthotropic(.thermoElastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .E3),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .G13),
                MaterialProperty(name: .G23),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu13),
                MaterialProperty(name: .nu23),
                MaterialProperty(name: .alpha11),
                MaterialProperty(name: .alpha22),
                MaterialProperty(name: .alpha33),
            ]
        case .monoclinic(.elastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .E3),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .G13),
                MaterialProperty(name: .G23),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu13),
                MaterialProperty(name: .nu23),
                MaterialProperty(name: .eta121),
                MaterialProperty(name: .eta122),
                MaterialProperty(name: .eta123),
                MaterialProperty(name: .eta1323),
                MaterialProperty(name: .eta2313),
            ]
        case .monoclinic(.thermoElastic):
            materialProperties = [
                MaterialProperty(name: .E1),
                MaterialProperty(name: .E2),
                MaterialProperty(name: .E3),
                MaterialProperty(name: .G12),
                MaterialProperty(name: .G13),
                MaterialProperty(name: .G23),
                MaterialProperty(name: .nu12),
                MaterialProperty(name: .nu13),
                MaterialProperty(name: .nu23),
                MaterialProperty(name: .eta121),
                MaterialProperty(name: .eta122),
                MaterialProperty(name: .eta123),
                MaterialProperty(name: .eta1323),
                MaterialProperty(name: .eta2313),
                MaterialProperty(name: .alpha11),
                MaterialProperty(name: .alpha22),
                MaterialProperty(name: .alpha33),
                MaterialProperty(name: .alpha12),
            ]
        case .anisotropic(.elastic):
            materialProperties = [
                MaterialProperty(name: .C11),
                MaterialProperty(name: .C12),
                MaterialProperty(name: .C13),
                MaterialProperty(name: .C14),
                MaterialProperty(name: .C15),
                MaterialProperty(name: .C16),
                MaterialProperty(name: .C22),
                MaterialProperty(name: .C23),
                MaterialProperty(name: .C24),
                MaterialProperty(name: .C25),
                MaterialProperty(name: .C26),
                MaterialProperty(name: .C33),
                MaterialProperty(name: .C34),
                MaterialProperty(name: .C35),
                MaterialProperty(name: .C36),
                MaterialProperty(name: .C44),
                MaterialProperty(name: .C45),
                MaterialProperty(name: .C46),
                MaterialProperty(name: .C55),
                MaterialProperty(name: .C56),
                MaterialProperty(name: .C66),
            ]
        case .anisotropic(.thermoElastic):
            materialProperties = [
                MaterialProperty(name: .C11),
                MaterialProperty(name: .C12),
                MaterialProperty(name: .C13),
                MaterialProperty(name: .C14),
                MaterialProperty(name: .C15),
                MaterialProperty(name: .C16),
                MaterialProperty(name: .C22),
                MaterialProperty(name: .C23),
                MaterialProperty(name: .C24),
                MaterialProperty(name: .C25),
                MaterialProperty(name: .C26),
                MaterialProperty(name: .C33),
                MaterialProperty(name: .C34),
                MaterialProperty(name: .C35),
                MaterialProperty(name: .C36),
                MaterialProperty(name: .C44),
                MaterialProperty(name: .C45),
                MaterialProperty(name: .C46),
                MaterialProperty(name: .C55),
                MaterialProperty(name: .C56),
                MaterialProperty(name: .C66),
                MaterialProperty(name: .alpha11),
                MaterialProperty(name: .alpha22),
                MaterialProperty(name: .alpha33),
                MaterialProperty(name: .alpha23),
                MaterialProperty(name: .alpha13),
                MaterialProperty(name: .alpha12),
            ]
        }
    }
}

// MARK: - public functions

extension Material {
    // MARK: - getMaterialTypeText

    func getMaterialTypeText() -> String {
        switch materialType {
        case .isotropic(.elastic), .isotropic(.thermoElastic):
            return "Isotropic"
        case .transverselyIsotropic(.elastic), .transverselyIsotropic(.thermoElastic):
            return "Transversely"
        case .orthotropic(.elastic), .orthotropic(.thermoElastic):
            return "Orthotropic"
        case .monoclinic(.elastic), .monoclinic(.thermoElastic):
            return "Monoclinic"
        case .anisotropic(.elastic), .anisotropic(.thermoElastic):
            return "Anisotropic"
        }
    }

    // MARK: - change analysis type

    func changeAnalysisType(to newTypeOfAnalysis: TypeOfAnalysis) {
        if analysisType == .elastic, newTypeOfAnalysis == .thermoElastic {
            switch materialType {
            case .isotropic:
                materialProperties += [
                    MaterialProperty(name: .alpha),
                ]
            case .transverselyIsotropic:
                materialProperties += [
                    MaterialProperty(name: .alpha11),
                    MaterialProperty(name: .alpha22),
                ]
            case .orthotropic:
                materialProperties += [
                    MaterialProperty(name: .alpha11),
                    MaterialProperty(name: .alpha22),
                    MaterialProperty(name: .alpha33),
                ]
            case .monoclinic:
                materialProperties += [
                    MaterialProperty(name: .alpha11),
                    MaterialProperty(name: .alpha22),
                    MaterialProperty(name: .alpha33),
                    MaterialProperty(name: .alpha12),
                ]
            case .anisotropic:
                materialProperties += [
                    MaterialProperty(name: .alpha11),
                    MaterialProperty(name: .alpha22),
                    MaterialProperty(name: .alpha33),
                    MaterialProperty(name: .alpha23),
                    MaterialProperty(name: .alpha13),
                    MaterialProperty(name: .alpha12),
                ]
            }
        } else if analysisType == .thermoElastic, newTypeOfAnalysis == .elastic {
            materialProperties = materialProperties.filter {
                $0.name != .alpha &&
                $0.name != .alpha11 &&
                $0.name != .alpha22 &&
                $0.name != .alpha33 &&
                $0.name != .alpha23 &&
                $0.name != .alpha13 &&
                $0.name != .alpha12
            }
        }
        analysisType = newTypeOfAnalysis
    }
}
