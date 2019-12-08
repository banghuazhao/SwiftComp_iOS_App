//
//  UDFRCAPI.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/6/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Moya

enum UDFRCAPI {
    case Homogenization(
        structuralModel: StructuralModel,
        typeOfAnalysis: TypeOfAnalysis,
        fiberVolumeFraction: VolumeFraction,
        fiberMaterial: Material,
        matrixMaterial: Material
    )
}

extension UDFRCAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(Constant.baseURL)/UDFRC")!
    }

    var path: String {
        switch self {
        case .Homogenization:
            return "/homogenization"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Homogenization:
            return .get
        }
    }

    var sampleData: Data {
        return "Test data".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case let .Homogenization(structuralModel, typeOfAnalysis, fiberVolumeFraction, fiberMaterial, matrixMaterial):

            var parameters: [String: Any] = [:]
            parameters["typeOfAnalysis"] = typeOfAnalysis.typeOfAnalysisAPI
            parameters["structuralModel"] = structuralModel.structrualModelAPI
            parameters["structuralSubmodel"] = structuralModel.structrualSubmodelAPI

            switch structuralModel.model {
            case .plate:
                parameters["k12_plate"] = structuralModel.plateExtraInput.k12
                parameters["k21_plate"] = structuralModel.plateExtraInput.k21
            case .beam:
                parameters["k11_beam"] = structuralModel.beamExtraInput.k11
                parameters["k12_beam"] = structuralModel.beamExtraInput.k12
                parameters["k13_beam"] = structuralModel.beamExtraInput.k13
                parameters["cos_angle1"] = structuralModel.beamExtraInput.cosAngle1
                parameters["cos_angle2"] = structuralModel.beamExtraInput.cosAngle2
            case .solid:
                break
            }
            
            parameters["fiberVolumeFraction"] = fiberVolumeFraction.value ?? 0.3
            
            if structuralModel.model != .solid(.cauchyContinuum) {
                parameters["squarePackLength"] = fiberVolumeFraction.cellLength ?? 1.0
            } else {
                parameters["squarePackLength"] = 1.0
            }

            // MARK: -  fiber material

            switch fiberMaterial.materialType {
            case .isotropic:
                parameters["fiberMaterialType"] = "Orthotropic"
                let E = fiberMaterial.materialProperties.first(where: { $0.name == .E })?.value ?? 0
                let nu = fiberMaterial.materialProperties.first(where: { $0.name == .nu })?.value ?? 0
                let G = E / (2 * (1 + nu))
                parameters["Ef1"] = E
                parameters["Ef2"] = E
                parameters["Ef3"] = E
                parameters["Gf12"] = G
                parameters["Gf13"] = G
                parameters["Gf23"] = G
                parameters["nuf12"] = nu
                parameters["nuf13"] = nu
                parameters["nuf23"] = nu
                if fiberMaterial.analysisType == .thermoElastic {
                    let alpha = fiberMaterial.materialProperties.first(where: { $0.name == .alpha })?.value ?? 0
                    parameters["alphaf11"] = alpha
                    parameters["alphaf22"] = alpha
                    parameters["alphaf33"] = alpha
                    parameters["alphaf23"] = 0
                    parameters["alphaf13"] = 0
                    parameters["alphaf12"] = 0
                }
            case .transverselyIsotropic:
                parameters["fiberMaterialType"] = "Orthotropic"
                let E1 = fiberMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = fiberMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let G12 = fiberMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let nu12 = fiberMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu23 = fiberMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                let E3 = E2
                let G13 = G12
                let G23 = E2 / (2 * (1 + nu23))
                let nu13 = nu12
                parameters["Ef1"] = E1
                parameters["Ef2"] = E2
                parameters["Ef3"] = E3
                parameters["Gf12"] = G12
                parameters["Gf13"] = G13
                parameters["Gf23"] = G23
                parameters["nuf12"] = nu12
                parameters["nuf13"] = nu13
                parameters["nuf23"] = nu23
                if fiberMaterial.analysisType == .thermoElastic {
                    let alpha11 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    parameters["alphaf11"] = alpha11
                    parameters["alphaf22"] = alpha22
                    parameters["alphaf33"] = alpha22
                    parameters["alphaf23"] = 0
                    parameters["alphaf13"] = 0
                    parameters["alphaf12"] = 0
                }
            case .orthotropic:
                parameters["fiberMaterialType"] = "Orthotropic"
                let E1 = fiberMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = fiberMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let E3 = fiberMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
                let G12 = fiberMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let G13 = fiberMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
                let G23 = fiberMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
                let nu12 = fiberMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu13 = fiberMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
                let nu23 = fiberMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                parameters["Ef1"] = E1
                parameters["Ef2"] = E2
                parameters["Ef3"] = E3
                parameters["Gf12"] = G12
                parameters["Gf13"] = G13
                parameters["Gf23"] = G23
                parameters["nuf12"] = nu12
                parameters["nuf13"] = nu13
                parameters["nuf23"] = nu23
                if fiberMaterial.analysisType == .thermoElastic {
                    let alpha11 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    parameters["alphaf11"] = alpha11
                    parameters["alphaf22"] = alpha22
                    parameters["alphaf33"] = alpha33
                    parameters["alphaf23"] = 0
                    parameters["alphaf13"] = 0
                    parameters["alphaf12"] = 0
                }
            default:
                break
            }

            // MARK: - materix material

            switch matrixMaterial.materialType {
            case .isotropic:
                parameters["matrixMaterialType"] = "Orthotropic"
                let E = matrixMaterial.materialProperties.first(where: { $0.name == .E })?.value ?? 0
                let nu = matrixMaterial.materialProperties.first(where: { $0.name == .nu })?.value ?? 0
                let G = E / (2 * (1 + nu))
                parameters["Em1"] = E
                parameters["Em2"] = E
                parameters["Em3"] = E
                parameters["Gm12"] = G
                parameters["Gm13"] = G
                parameters["Gm23"] = G
                parameters["num12"] = nu
                parameters["num13"] = nu
                parameters["num23"] = nu
                if matrixMaterial.analysisType == .thermoElastic {
                    let alpha = matrixMaterial.materialProperties.first(where: { $0.name == .alpha })?.value ?? 0
                    parameters["alpham11"] = alpha
                    parameters["alpham22"] = alpha
                    parameters["alpham33"] = alpha
                    parameters["alpham23"] = 0
                    parameters["alpham13"] = 0
                    parameters["alpham12"] = 0
                }
            case .transverselyIsotropic:
                parameters["matrixMaterialType"] = "Orthotropic"
                let E1 = matrixMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = matrixMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let G12 = matrixMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let nu12 = matrixMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu23 = matrixMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                let E3 = E2
                let G13 = G12
                let G23 = E2 / (2 * (1 + nu23))
                let nu13 = nu12
                parameters["Em1"] = E1
                parameters["Em2"] = E2
                parameters["Em3"] = E3
                parameters["Gm12"] = G12
                parameters["Gm13"] = G13
                parameters["Gm23"] = G23
                parameters["num12"] = nu12
                parameters["num13"] = nu13
                parameters["num23"] = nu23
                if matrixMaterial.analysisType == .thermoElastic {
                    let alpha11 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    parameters["alpham11"] = alpha11
                    parameters["alpham22"] = alpha22
                    parameters["alpham33"] = alpha22
                    parameters["alpham23"] = 0
                    parameters["alpham13"] = 0
                    parameters["alpham12"] = 0
                }
            case .orthotropic:
                parameters["matrixMaterialType"] = "Orthotropic"
                let E1 = matrixMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = matrixMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let E3 = matrixMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
                let G12 = matrixMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let G13 = matrixMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
                let G23 = matrixMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
                let nu12 = matrixMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu13 = matrixMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
                let nu23 = matrixMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                parameters["Em1"] = E1
                parameters["Em2"] = E2
                parameters["Em3"] = E3
                parameters["Gm12"] = G12
                parameters["Gm13"] = G13
                parameters["Gm23"] = G23
                parameters["num12"] = nu12
                parameters["num13"] = nu13
                parameters["num23"] = nu23
                if matrixMaterial.analysisType == .thermoElastic {
                    let alpha11 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    parameters["alpham11"] = alpha11
                    parameters["alpham22"] = alpha22
                    parameters["alpham33"] = alpha33
                    parameters["alpham23"] = 0
                    parameters["alpham13"] = 0
                    parameters["alpham12"] = 0
                }
            default:
                break
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
