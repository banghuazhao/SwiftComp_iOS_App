//
//  HoneycombAPI.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/29/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Moya

enum HoneycombAPI {
    case Homogenization(
        structuralModel: StructuralModel,
        typeOfAnalysis: TypeOfAnalysis,
        honeycombCore: HoneycombCore,
        stackingSequence: StackingSequence,
        coreMaterial: Material,
        facesheetMaterial: Material
    )
}

extension HoneycombAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://128.46.6.100:8888/honeycombSandwich")!
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
        return "Test data".utf8Encoded
    }

    var task: Task {
        switch self {
        case let .Homogenization(structuralModel, typeOfAnalysis, honeycombCore, stackingSequence, coreMaterial, facesheetMaterial):

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

            parameters["coreLength"] = honeycombCore.coreLength
            parameters["coreThickness"] = honeycombCore.coreThickness
            parameters["coreHeight"] = honeycombCore.coreHeight

            parameters["stackingSequence"] = stackingSequence.stackingSequenceAPI
            parameters["layerThickness"] = stackingSequence.layerThickness

            // MARK: -  core material

            switch coreMaterial.materialType {
            case .isotropic:
                parameters["coreMaterialType"] = "Orthotropic"
                let E = coreMaterial.materialProperties.first(where: { $0.name == .E })?.value ?? 0
                let nu = coreMaterial.materialProperties.first(where: { $0.name == .nu })?.value ?? 0
                let G = E / (2 * (1 + nu))
                parameters["Ec1"] = E
                parameters["Ec2"] = E
                parameters["Ec3"] = E
                parameters["Gc12"] = G
                parameters["Gc13"] = G
                parameters["Gc23"] = G
                parameters["nuc12"] = nu
                parameters["nuc13"] = nu
                parameters["nuc23"] = nu
                if coreMaterial.analysisType == .thermoElastic {
                    let alpha = coreMaterial.materialProperties.first(where: { $0.name == .alpha })?.value ?? 0
                    parameters["alphac11"] = alpha
                    parameters["alphac22"] = alpha
                    parameters["alphac33"] = alpha
                    parameters["alphac23"] = 0
                    parameters["alphac13"] = 0
                    parameters["alphac12"] = 0
                }
            case .transverselyIsotropic:
                parameters["coreMaterialType"] = "Orthotropic"
                let E1 = coreMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = coreMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let G12 = coreMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let nu12 = coreMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu23 = coreMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                let E3 = E2
                let G13 = G12
                let G23 = E2 / (2 * (1 + nu23))
                let nu13 = nu12
                parameters["Ec1"] = E1
                parameters["Ec2"] = E2
                parameters["Ec3"] = E3
                parameters["Gc12"] = G12
                parameters["Gc13"] = G13
                parameters["Gc23"] = G23
                parameters["nuc12"] = nu12
                parameters["nuc13"] = nu13
                parameters["nuc23"] = nu23
                if coreMaterial.analysisType == .thermoElastic {
                    let alpha11 = coreMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = coreMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    parameters["alphac11"] = alpha11
                    parameters["alphac22"] = alpha22
                    parameters["alphac33"] = alpha22
                    parameters["alphac23"] = 0
                    parameters["alphac13"] = 0
                    parameters["alphac12"] = 0
                }
            case .orthotropic:
                parameters["coreMaterialType"] = "Orthotropic"
                let E1 = coreMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = coreMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let E3 = coreMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
                let G12 = coreMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let G13 = coreMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
                let G23 = coreMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
                let nu12 = coreMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu13 = coreMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
                let nu23 = coreMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                parameters["Ec1"] = E1
                parameters["Ec2"] = E2
                parameters["Ec3"] = E3
                parameters["Gc12"] = G12
                parameters["Gc13"] = G13
                parameters["Gc23"] = G23
                parameters["nuc12"] = nu12
                parameters["nuc13"] = nu13
                parameters["nuc23"] = nu23
                if coreMaterial.analysisType == .thermoElastic {
                    let alpha11 = coreMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = coreMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = coreMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    parameters["alphac11"] = alpha11
                    parameters["alphac22"] = alpha22
                    parameters["alphac33"] = alpha33
                    parameters["alphac23"] = 0
                    parameters["alphac13"] = 0
                    parameters["alphac12"] = 0
                }
            default:
                break
            }

            // MARK: -  facesheet material

            switch facesheetMaterial.materialType {
            case .transverselyIsotropic:
                parameters["laminaMaterialType"] = "Orthotropic"
                let E1 = facesheetMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = facesheetMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let G12 = facesheetMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let nu12 = facesheetMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu23 = facesheetMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                let E3 = E2
                let G13 = G12
                let G23 = E2 / (2 * (1 + nu23))
                let nu13 = nu12
                parameters["El1"] = E1
                parameters["El2"] = E2
                parameters["El3"] = E3
                parameters["Gl12"] = G12
                parameters["Gl13"] = G13
                parameters["Gl23"] = G23
                parameters["nul12"] = nu12
                parameters["nul13"] = nu13
                parameters["nul23"] = nu23
                if facesheetMaterial.analysisType == .thermoElastic {
                    let alpha11 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    parameters["alphal11"] = alpha11
                    parameters["alphal22"] = alpha22
                    parameters["alphal33"] = alpha22
                    parameters["alphal23"] = 0
                    parameters["alphal13"] = 0
                    parameters["alphal12"] = 0
                }
            case .orthotropic:
                parameters["laminaMaterialType"] = "Orthotropic"
                let E1 = facesheetMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
                let E2 = facesheetMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
                let E3 = facesheetMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
                let G12 = facesheetMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
                let G13 = facesheetMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
                let G23 = facesheetMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
                let nu12 = facesheetMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
                let nu13 = facesheetMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
                let nu23 = facesheetMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
                parameters["El1"] = E1
                parameters["El2"] = E2
                parameters["El3"] = E3
                parameters["Gl12"] = G12
                parameters["Gl13"] = G13
                parameters["Gl23"] = G23
                parameters["nul12"] = nu12
                parameters["nul13"] = nu13
                parameters["nul23"] = nu23
                if facesheetMaterial.analysisType == .thermoElastic {
                    let alpha11 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    parameters["alphal11"] = alpha11
                    parameters["alphal22"] = alpha22
                    parameters["alphal33"] = alpha33
                    parameters["alphal23"] = 0
                    parameters["alphal13"] = 0
                    parameters["alphal12"] = 0
                }
            case .anisotropic:
                parameters["laminaMaterialType"] = "Anisotropic"
                let C11 = facesheetMaterial.materialProperties.first(where: { $0.name == .C11 })?.value ?? 0
                let C12 = facesheetMaterial.materialProperties.first(where: { $0.name == .C12 })?.value ?? 0
                let C13 = facesheetMaterial.materialProperties.first(where: { $0.name == .C13 })?.value ?? 0
                let C14 = facesheetMaterial.materialProperties.first(where: { $0.name == .C14 })?.value ?? 0
                let C15 = facesheetMaterial.materialProperties.first(where: { $0.name == .C15 })?.value ?? 0
                let C16 = facesheetMaterial.materialProperties.first(where: { $0.name == .C16 })?.value ?? 0
                let C22 = facesheetMaterial.materialProperties.first(where: { $0.name == .C22 })?.value ?? 0
                let C23 = facesheetMaterial.materialProperties.first(where: { $0.name == .C23 })?.value ?? 0
                let C24 = facesheetMaterial.materialProperties.first(where: { $0.name == .C24 })?.value ?? 0
                let C25 = facesheetMaterial.materialProperties.first(where: { $0.name == .C25 })?.value ?? 0
                let C26 = facesheetMaterial.materialProperties.first(where: { $0.name == .C26 })?.value ?? 0
                let C33 = facesheetMaterial.materialProperties.first(where: { $0.name == .C33 })?.value ?? 0
                let C34 = facesheetMaterial.materialProperties.first(where: { $0.name == .C34 })?.value ?? 0
                let C35 = facesheetMaterial.materialProperties.first(where: { $0.name == .C35 })?.value ?? 0
                let C36 = facesheetMaterial.materialProperties.first(where: { $0.name == .C36 })?.value ?? 0
                let C44 = facesheetMaterial.materialProperties.first(where: { $0.name == .C44 })?.value ?? 0
                let C45 = facesheetMaterial.materialProperties.first(where: { $0.name == .C45 })?.value ?? 0
                let C46 = facesheetMaterial.materialProperties.first(where: { $0.name == .C46 })?.value ?? 0
                let C55 = facesheetMaterial.materialProperties.first(where: { $0.name == .C55 })?.value ?? 0
                let C56 = facesheetMaterial.materialProperties.first(where: { $0.name == .C56 })?.value ?? 0
                let C66 = facesheetMaterial.materialProperties.first(where: { $0.name == .C66 })?.value ?? 0
                parameters["Cl11"] = C11
                parameters["Cl12"] = C12
                parameters["Cl13"] = C13
                parameters["Cl14"] = C14
                parameters["Cl15"] = C15
                parameters["Cl16"] = C16
                parameters["Cl22"] = C22
                parameters["Cl23"] = C23
                parameters["Cl24"] = C24
                parameters["Cl25"] = C25
                parameters["Cl26"] = C26
                parameters["Cl33"] = C33
                parameters["Cl34"] = C34
                parameters["Cl35"] = C35
                parameters["Cl36"] = C36
                parameters["Cl44"] = C44
                parameters["Cl45"] = C45
                parameters["Cl46"] = C46
                parameters["Cl55"] = C55
                parameters["Cl56"] = C56
                parameters["Cl66"] = C66
                if facesheetMaterial.analysisType == .thermoElastic {
                    let alpha11 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                    let alpha22 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                    let alpha33 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                    let alpha23 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha23 })?.value ?? 0
                    let alpha13 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha13 })?.value ?? 0
                    let alpha12 = facesheetMaterial.materialProperties.first(where: { $0.name == .alpha12 })?.value ?? 0
                    parameters["alphal11"] = alpha11
                    parameters["alphal22"] = alpha22
                    parameters["alphal33"] = alpha33
                    parameters["alphal23"] = alpha23
                    parameters["alphal13"] = alpha13
                    parameters["alphal12"] = alpha12
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

// MARK: - Helpers

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
