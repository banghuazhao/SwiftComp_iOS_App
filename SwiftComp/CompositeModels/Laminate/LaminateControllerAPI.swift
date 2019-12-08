//
//  LaminateControllerAPI.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/3/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Moya

enum LaminateControllerAPI {
    case Homogenization(
        structuralModel: StructuralModel,
        typeOfAnalysis: TypeOfAnalysis,
        stackingSequence: StackingSequence,
        laminaMaterial: Material
    )
}

extension LaminateControllerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(Constant.baseURL)/laminate")!
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
        case let .Homogenization(structuralModel, typeOfAnalysis, stackingSequence, laminaMaterial):

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


            parameters["stackingSequence"] = stackingSequence.stackingSequenceAPI
            parameters["layerThickness"] = stackingSequence.layerThickness

            // MARK: -  lamina material

            switch laminaMaterial.materialType {
            case .transverselyIsotropic:
                parameters["laminaMaterialType"] = "Orthotropic"
                let E1 = laminaMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = laminaMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let G12 = laminaMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let nu12 = laminaMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu23 = laminaMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                let E3 = E2
                let G13 = G12
                let G23 = E2 / (2 * (1 + nu23))
                let nu13 = nu12
                parameters["E1"] = E1
                parameters["E2"] = E2
                parameters["E3"] = E3
                parameters["G12"] = G12
                parameters["G13"] = G13
                parameters["G23"] = G23
                parameters["nu12"] = nu12
                parameters["nu13"] = nu13
                parameters["nu23"] = nu23
                if laminaMaterial.analysisType == .thermoElastic {
                    let alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    parameters["alpha11"] = alpha11
                    parameters["alpha22"] = alpha22
                    parameters["alpha33"] = alpha22
                    parameters["alpha23"] = 0
                    parameters["alpha13"] = 0
                    parameters["alpha12"] = 0
                }
            case .orthotropic:
                parameters["laminaMaterialType"] = "Orthotropic"
                let E1 = laminaMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = laminaMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let E3 = laminaMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
                let G12 = laminaMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let G13 = laminaMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
                let G23 = laminaMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
                let nu12 = laminaMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu13 = laminaMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
                let nu23 = laminaMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                parameters["E1"] = E1
                parameters["E2"] = E2
                parameters["E3"] = E3
                parameters["G12"] = G12
                parameters["G13"] = G13
                parameters["G23"] = G23
                parameters["nu12"] = nu12
                parameters["nu13"] = nu13
                parameters["nu23"] = nu23
                if laminaMaterial.analysisType == .thermoElastic {
                    let alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    parameters["alpha11"] = alpha11
                    parameters["alpha22"] = alpha22
                    parameters["alpha33"] = alpha33
                    parameters["alpha23"] = 0
                    parameters["alpha13"] = 0
                    parameters["alpha12"] = 0
                }
            case .anisotropic:
                parameters["laminaMaterialType"] = "Anisotropic"
                let C11 = laminaMaterial.materialProperties.first(where: { $0.name == .C11 })?.value ?? 0
                let C12 = laminaMaterial.materialProperties.first(where: { $0.name == .C12 })?.value ?? 0
                let C13 = laminaMaterial.materialProperties.first(where: { $0.name == .C13 })?.value ?? 0
                let C14 = laminaMaterial.materialProperties.first(where: { $0.name == .C14 })?.value ?? 0
                let C15 = laminaMaterial.materialProperties.first(where: { $0.name == .C15 })?.value ?? 0
                let C16 = laminaMaterial.materialProperties.first(where: { $0.name == .C16 })?.value ?? 0
                let C22 = laminaMaterial.materialProperties.first(where: { $0.name == .C22 })?.value ?? 0
                let C23 = laminaMaterial.materialProperties.first(where: { $0.name == .C23 })?.value ?? 0
                let C24 = laminaMaterial.materialProperties.first(where: { $0.name == .C24 })?.value ?? 0
                let C25 = laminaMaterial.materialProperties.first(where: { $0.name == .C25 })?.value ?? 0
                let C26 = laminaMaterial.materialProperties.first(where: { $0.name == .C26 })?.value ?? 0
                let C33 = laminaMaterial.materialProperties.first(where: { $0.name == .C33 })?.value ?? 0
                let C34 = laminaMaterial.materialProperties.first(where: { $0.name == .C34 })?.value ?? 0
                let C35 = laminaMaterial.materialProperties.first(where: { $0.name == .C35 })?.value ?? 0
                let C36 = laminaMaterial.materialProperties.first(where: { $0.name == .C36 })?.value ?? 0
                let C44 = laminaMaterial.materialProperties.first(where: { $0.name == .C44 })?.value ?? 0
                let C45 = laminaMaterial.materialProperties.first(where: { $0.name == .C45 })?.value ?? 0
                let C46 = laminaMaterial.materialProperties.first(where: { $0.name == .C46 })?.value ?? 0
                let C55 = laminaMaterial.materialProperties.first(where: { $0.name == .C55 })?.value ?? 0
                let C56 = laminaMaterial.materialProperties.first(where: { $0.name == .C56 })?.value ?? 0
                let C66 = laminaMaterial.materialProperties.first(where: { $0.name == .C66 })?.value ?? 0
                parameters["C11"] = C11
                parameters["C12"] = C12
                parameters["C13"] = C13
                parameters["C14"] = C14
                parameters["C15"] = C15
                parameters["C16"] = C16
                parameters["C22"] = C22
                parameters["C23"] = C23
                parameters["C24"] = C24
                parameters["C25"] = C25
                parameters["C26"] = C26
                parameters["C33"] = C33
                parameters["C34"] = C34
                parameters["C35"] = C35
                parameters["C36"] = C36
                parameters["C44"] = C44
                parameters["C45"] = C45
                parameters["C46"] = C46
                parameters["C55"] = C55
                parameters["C56"] = C56
                parameters["C66"] = C66
                if laminaMaterial.analysisType == .thermoElastic {
                    let alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    let alpha23 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha23 })?.value ?? 0
                    let alpha13 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha13 })?.value ?? 0
                    let alpha12 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha12 })?.value ?? 0
                    parameters["alpha11"] = alpha11
                    parameters["alpha22"] = alpha22
                    parameters["alpha33"] = alpha33
                    parameters["alpha23"] = alpha23
                    parameters["alpha13"] = alpha13
                    parameters["alpha12"] = alpha12
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
