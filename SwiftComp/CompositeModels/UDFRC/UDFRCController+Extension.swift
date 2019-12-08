//
//  UDFRCController+Extension.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/7/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Accelerate
import UIKit

extension UDFRCController {
    func ROMCalculate() {
        // solid model result
        var effectiveSolidStiffness: [String: String] = [:]
        var engineeringConstants: [String: String] = [:]

        // thermal result
        var thermalCoefficients: [String: String]?

        var Vf = fiberVolumeFraction.value ?? 0.0 // fiber volume fraction

        var (ef1, ef2, ef3, gf12, gf13, gf23, nuf12, nuf13, nuf23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var (alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        var (em1, em2, em3, gm12, gm13, gm23, num12, num13, num23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var (alpham11, alpham22, alpham33, alpham23, alpham13, alpham12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        let fiberMaterial = fiberMaterials.selectedMaterial
        let matrixMaterial = matrixMaterials.selectedMaterial

        // MARK: - fiber material

        switch fiberMaterial.materialType {
        case .isotropic:
            let E = fiberMaterial.materialProperties.first(where: { $0.name == .E })?.value ?? 0
            let nu = fiberMaterial.materialProperties.first(where: { $0.name == .nu })?.value ?? 0
            let G = E / (2 * (1 + nu))
            ef1 = E
            ef2 = E
            ef3 = E
            gf12 = G
            gf13 = G
            gf23 = G
            nuf12 = nu
            nuf13 = nu
            nuf23 = nu
            if fiberMaterial.analysisType == .thermoElastic {
                let alpha = fiberMaterial.materialProperties.first(where: { $0.name == .alpha })?.value ?? 0
                alphaf11 = alpha
                alphaf22 = alpha
                alphaf33 = alpha
                alphaf23 = 0
                alphaf13 = 0
                alphaf12 = 0
            }
        case .transverselyIsotropic:
            ef1 = fiberMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            ef2 = fiberMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            gf12 = fiberMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            nuf12 = fiberMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            nuf23 = fiberMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            ef3 = ef2
            gf13 = gf12
            gf23 = ef2 / (2 * (1 + nuf23))
            nuf13 = nuf12
            if fiberMaterial.analysisType == .thermoElastic {
                alphaf11 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alphaf22 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alphaf33 = alphaf22
                alphaf23 = 0
                alphaf13 = 0
                alphaf12 = 0
            }
        case .orthotropic:
            ef1 = fiberMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            ef2 = fiberMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            ef3 = fiberMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
            gf12 = fiberMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            gf13 = fiberMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
            gf23 = fiberMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
            nuf12 = fiberMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            nuf13 = fiberMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
            nuf23 = fiberMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            if fiberMaterial.analysisType == .thermoElastic {
                alphaf11 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alphaf22 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alphaf33 = fiberMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                alphaf23 = 0
                alphaf13 = 0
                alphaf12 = 0
            }
        default:
            break
        }

        // MARK: - matrix material

        switch matrixMaterial.materialType {
        case .isotropic:
            let E = matrixMaterial.materialProperties.first(where: { $0.name == .E })?.value ?? 0
            let nu = matrixMaterial.materialProperties.first(where: { $0.name == .nu })?.value ?? 0
            let G = E / (2 * (1 + nu))
            em1 = E
            em2 = E
            em3 = E
            gm12 = G
            gm13 = G
            gm23 = G
            num12 = nu
            num13 = nu
            num23 = nu
            if matrixMaterial.analysisType == .thermoElastic {
                let alpha = matrixMaterial.materialProperties.first(where: { $0.name == .alpha })?.value ?? 0
                alpham11 = alpha
                alpham22 = alpha
                alpham33 = alpha
                alpham23 = 0
                alpham13 = 0
                alpham12 = 0
            }
        case .transverselyIsotropic:
            em1 = matrixMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            em2 = matrixMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            gm12 = matrixMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            num12 = matrixMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            num23 = matrixMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            em3 = em2
            gm13 = gm12
            gm23 = em2 / (2 * (1 + num23))
            num13 = num12
            if matrixMaterial.analysisType == .thermoElastic {
                alpham11 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alpham22 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alpham33 = alpham22
                alpham23 = 0
                alpham13 = 0
                alpham12 = 0
            }
        case .orthotropic:
            em1 = matrixMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            em2 = matrixMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            em3 = matrixMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
            gm12 = matrixMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            gm13 = matrixMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
            gm23 = matrixMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
            num12 = matrixMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            num13 = matrixMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
            num23 = matrixMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            if matrixMaterial.analysisType == .thermoElastic {
                alpham11 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alpham22 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alpham33 = matrixMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                alpham23 = 0
                alpham13 = 0
                alpham12 = 0
            }
        default:
            break
        }

        var Sf: [Double] = []
        var Sm: [Double] = []
        var SHf: [Double] = []
        var SHm: [Double] = []

        Sf = [1 / ef1, -nuf12 / ef1, -nuf13 / ef1, 0, 0, 0, -nuf12 / ef1, 1 / ef2, -nuf23 / ef2, 0, 0, 0, -nuf12 / ef1, -nuf23 / ef2, 1 / ef3, 0, 0, 0, 0, 0, 0, 1 / gf23, 0, 0, 0, 0, 0, 0, 1 / gf13, 0, 0, 0, 0, 0, 0, 1 / gf12]
        SHf = [ef1, nuf12, nuf13, 0, 0, 0, -nuf12, 1 / ef2 - nuf12 * nuf12 / ef1, -nuf23 / ef2 - nuf13 * nuf13 / ef1, 0, 0, 0, -nuf23, -nuf23 / ef2 - nuf12 * nuf12 / ef1, 1 / ef3 - nuf13 * nuf13 / ef1, 0, 0, 0, 0, 0, 0, 1 / gf23, 0, 0, 0, 0, 0, 0, 1 / gf13, 0, 0, 0, 0, 0, 0, 1 / gf12]

        Sm = [1 / em1, -num12 / em1, -num13 / em1, 0, 0, 0, -num12 / em1, 1 / em2, -num23 / em2, 0, 0, 0, -num12 / em1, -num23 / em2, 1 / em3, 0, 0, 0, 0, 0, 0, 1 / gm23, 0, 0, 0, 0, 0, 0, 1 / gm13, 0, 0, 0, 0, 0, 0, 1 / gm12]
        SHm = [em1, num12, num13, 0, 0, 0, -num12, 1 / em2 - num12 * num12 / em1, -num23 / em2 - num13 * num13 / em1, 0, 0, 0, -num23, -num23 / em2 - num12 * num12 / em1, 1 / em3 - num13 * num13 / em1, 0, 0, 0, 0, 0, 0, 1 / gm23, 0, 0, 0, 0, 0, 0, 1 / gm13, 0, 0, 0, 0, 0, 0, 1 / gm12]

        var SRs = [Double](repeating: 0, count: 36)
        var SVs = [Double](repeating: 0, count: 36)
        var SHs = [Double](repeating: 0, count: 36)

        var Cf = [Double](repeating: 0, count: 36)
        var Cm = [Double](repeating: 0, count: 36)
        var CVs = [Double](repeating: 0, count: 36)
        var CRs = [Double](repeating: 0, count: 36)

        var temp1 = [Double](repeating: 0, count: 36)
        var temp2 = [Double](repeating: 0, count: 36)

        var Vm = 1 - Vf

        vDSP_vsmulD(Sf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(Sm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &SRs, 1, 36)

        vDSP_vsmulD(SHf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(SHm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &SHs, 1, 36)

        Cf = invert(matrix: Sf)
        Cm = invert(matrix: Sm)

        vDSP_vsmulD(Cf, 1, &Vf, &temp1, 1, 36)
        vDSP_vsmulD(Cm, 1, &Vm, &temp2, 1, 36)
        vDSP_vaddD(temp1, 1, temp2, 1, &CVs, 1, 36)

        SVs = invert(matrix: CVs)
        CRs = invert(matrix: SRs)

        // Voigt results
        let eV1 = 1 / SVs[0]
        let eV2 = 1 / SVs[7]
        let eV3 = 1 / SVs[14]
        let gV12 = 1 / SVs[35]
        let gV13 = 1 / SVs[28]
        let gV23 = 1 / SVs[21]
        let nuV12 = -1 / SVs[0] * SVs[1]
        let nuV13 = -1 / SVs[0] * SVs[2]
        let nuV23 = -1 / SVs[7] * SVs[8]

        // Reuss results
        let eR1 = 1 / SRs[0]
        let eR2 = 1 / SRs[7]
        let eR3 = 1 / SRs[14]
        let gR12 = 1 / SRs[35]
        let gR13 = 1 / SRs[28]
        let gR23 = 1 / SRs[21]
        let nuR12 = -1 / SRs[0] * SRs[1]
        let nuR13 = -1 / SRs[0] * SRs[2]
        let nuR23 = -1 / SRs[7] * SRs[8]

        // Hybird results
        let eH1 = SHs[0]

        let nuH12 = SHs[1]
        let nuH13 = SHs[2]

        let gH12 = SHs[35]
        let gH13 = SHs[28]
        let gH23 = SHs[21]

        let eH2 = 1 / (SHs[7] + nuH12 * nuH12 / eH1)
        let eH3 = 1 / (SHs[14] + nuH13 * nuH13 / eH1)

        let nuH23 = -eH2 * (SHs[8] + nuH12 * nuH12 / eH1)

        var SHsEngineering = [Double](repeating: 0, count: 36)
        var CHsEngineering = [Double](repeating: 0, count: 36)

        SHsEngineering = [1 / eH1, -nuH12 / eH1, -nuH13 / eH1, 0, 0, 0, -nuH12 / eH1, 1 / eH2, -nuH23 / eH2, 0, 0, 0, -nuH12 / eH1, -nuH23 / eH2, 1 / eH3, 0, 0, 0, 0, 0, 0, 1 / gH23, 0, 0, 0, 0, 0, 0, 1 / gH13, 0, 0, 0, 0, 0, 0, 1 / gH12]
        CHsEngineering = invert(matrix: SHsEngineering)

        // MARK: - elastic result

        var (er1, er2, er3, gr12, gr13, gr23, nur12, nur13, nur23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var Cr = [Double](repeating: 0, count: 36)

        if method == .nonSwiftComp(.voigtROM) {
            er1 = eV1
            er2 = eV2
            er3 = eV3
            gr12 = gV12
            gr13 = gV13
            gr23 = gV23
            nur12 = nuV12
            nur13 = nuV13
            nur23 = nuV23
            Cr = CVs
        } else if method == .nonSwiftComp(.reussROM) {
            er1 = eR1
            er2 = eR2
            er3 = eR3
            gr12 = gR12
            gr13 = gR13
            gr23 = gR23
            nur12 = nuR12
            nur13 = nuR13
            nur23 = nuR23
            Cr = CRs
        } else if method == .nonSwiftComp(.hybridROM) {
            er1 = eH1
            er2 = eH2
            er3 = eH3
            gr12 = gH12
            gr13 = gH13
            gr23 = gH23
            nur12 = nuH12
            nur13 = nuH13
            nur23 = nuH23
            Cr = CHsEngineering
        }

        // effective solid stiffness
        effectiveSolidStiffness["C11"] = String(Cr[0])
        effectiveSolidStiffness["C12"] = String(Cr[1])
        effectiveSolidStiffness["C13"] = String(Cr[2])
        effectiveSolidStiffness["C14"] = String(Cr[3])
        effectiveSolidStiffness["C15"] = String(Cr[4])
        effectiveSolidStiffness["C16"] = String(Cr[5])

        effectiveSolidStiffness["C21"] = String(Cr[6])
        effectiveSolidStiffness["C22"] = String(Cr[7])
        effectiveSolidStiffness["C23"] = String(Cr[8])
        effectiveSolidStiffness["C24"] = String(Cr[9])
        effectiveSolidStiffness["C25"] = String(Cr[10])
        effectiveSolidStiffness["C26"] = String(Cr[11])

        effectiveSolidStiffness["C31"] = String(Cr[12])
        effectiveSolidStiffness["C32"] = String(Cr[13])
        effectiveSolidStiffness["C33"] = String(Cr[14])
        effectiveSolidStiffness["C34"] = String(Cr[15])
        effectiveSolidStiffness["C35"] = String(Cr[16])
        effectiveSolidStiffness["C36"] = String(Cr[17])

        effectiveSolidStiffness["C41"] = String(Cr[18])
        effectiveSolidStiffness["C42"] = String(Cr[19])
        effectiveSolidStiffness["C43"] = String(Cr[20])
        effectiveSolidStiffness["C44"] = String(Cr[21])
        effectiveSolidStiffness["C45"] = String(Cr[22])
        effectiveSolidStiffness["C46"] = String(Cr[23])

        effectiveSolidStiffness["C51"] = String(Cr[24])
        effectiveSolidStiffness["C52"] = String(Cr[25])
        effectiveSolidStiffness["C53"] = String(Cr[26])
        effectiveSolidStiffness["C54"] = String(Cr[27])
        effectiveSolidStiffness["C55"] = String(Cr[28])
        effectiveSolidStiffness["C56"] = String(Cr[29])

        effectiveSolidStiffness["C61"] = String(Cr[30])
        effectiveSolidStiffness["C62"] = String(Cr[31])
        effectiveSolidStiffness["C63"] = String(Cr[32])
        effectiveSolidStiffness["C64"] = String(Cr[33])
        effectiveSolidStiffness["C65"] = String(Cr[34])
        effectiveSolidStiffness["C66"] = String(Cr[35])

        // engineering constants
        engineeringConstants["E1"] = String(er1)
        engineeringConstants["E2"] = String(er2)
        engineeringConstants["E3"] = String(er3)
        engineeringConstants["G12"] = String(gr12)
        engineeringConstants["G13"] = String(gr13)
        engineeringConstants["G23"] = String(gr23)
        engineeringConstants["nu12"] = String(nur12)
        engineeringConstants["nu13"] = String(nur13)
        engineeringConstants["nu23"] = String(nur23)

        if typeOfAnalysis == .thermoElastic {
            let alphaf: [Double] = [alphaf11, alphaf22, alphaf33, alphaf23, alphaf13, alphaf12]
            let alpham: [Double] = [alpham11, alpham22, alpham33, alpham23, alpham13, alpham12]

            let alphaf11 = alphaf[0]
            let alphaf22 = alphaf[1]
            let alphaf33 = alphaf[2]

            let alpham11 = alpham[0]
            let alpham22 = alpham[1]
            let alpham33 = alpham[2]

            var temp3 = [Double](repeating: 0, count: 6)
            var temp4 = [Double](repeating: 0, count: 6)
            vDSP_mmulD(Cf, 1, alphaf, 1, &temp3, 1, 6, 1, 6)
            vDSP_mmulD(Cm, 1, alpham, 1, &temp4, 1, 6, 1, 6)

            var temp5 = [Double](repeating: 0, count: 6)
            vDSP_vsmulD(temp3, 1, &Vf, &temp1, 1, 6)
            vDSP_vsmulD(temp4, 1, &Vm, &temp2, 1, 6)
            vDSP_vaddD(temp1, 1, temp2, 1, &temp5, 1, 6)

            var alphamVs = [Double](repeating: 0, count: 6)
            vDSP_mmulD(SVs, 1, temp5, 1, &alphamVs, 1, 6, 1, 6)

            let alphaV11 = alphamVs[0]
            let alphaV22 = alphamVs[1]
            let alphaV33 = alphamVs[2]

            let alphamRs: [Double] = [Vf * alphaf11 + Vm * alpham11, Vf * alphaf22 + Vm * alpham22, Vf * alphaf33 + Vm * alpham33, 0, 0, 0]

            let alphaR11 = alphamRs[0]
            let alphaR22 = alphamRs[1]
            let alphaR33 = alphamRs[2]

            let ef1 = 1 / Sf[0]
            let vf12 = -ef1 * Sf[1]
            let vf13 = -ef1 * Sf[2]

            let em1 = 1 / Sm[0]
            let vm12 = -em1 * Sm[1]
            let vm13 = -em1 * Sm[2]

            let alphaHf: [Double] = [-ef1 * alphaf11, alphaf11 * vf12 + alphaf22, alphaf11 * vf13 + alphaf33, 0, 0, 0]
            let alphaHm: [Double] = [-em1 * alpham11, alpham11 * vm12 + alpham22, alpham11 * vm13 + alpham33, 0, 0, 0]

            var tempAlphaf = [Double](repeating: 0, count: 6)
            var tempAlpham = [Double](repeating: 0, count: 6)

            var alphaHs = [Double](repeating: 0, count: 6)

            vDSP_vsmulD(alphaHf, 1, &Vf, &tempAlphaf, 1, 6)
            vDSP_vsmulD(alphaHm, 1, &Vm, &tempAlpham, 1, 6)
            vDSP_vaddD(tempAlphaf, 1, tempAlpham, 1, &alphaHs, 1, 6)

            let alphaH11 = -alphaHs[0] / eH1
            let alphaH22 = alphaHs[1] - alphaH11 * nuH12
            let alphaH33 = alphaHs[2] - alphaH11 * nuH13

            // MARK: - thermal result

            var (alphar11, alphar22, alphar33, alphar23, alphar13, alphar12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            if method == .nonSwiftComp(.voigtROM) {
                alphar11 = alphaV11
                alphar22 = alphaV22
                alphar33 = alphaV33
            } else if method == .nonSwiftComp(.reussROM) {
                alphar11 = alphaR11
                alphar22 = alphaR22
                alphar33 = alphaR33

            } else if method == .nonSwiftComp(.hybridROM) {
                alphar11 = alphaH11
                alphar22 = alphaH22
                alphar33 = alphaH33
            }

            alphar23 = 0
            alphar13 = 0
            alphar12 = 0

            thermalCoefficients = [:]
            thermalCoefficients!["alpha11"] = String(alphar11)
            thermalCoefficients!["alpha22"] = String(alphar22)
            thermalCoefficients!["alpha33"] = String(alphar33)
            thermalCoefficients!["alpha23"] = String(alphar23)
            thermalCoefficients!["alpha13"] = String(alphar13)
            thermalCoefficients!["alpha12"] = String(alphar12)
        }

        // MARK: - push result controller

        let homResultController = HomResultController()
        switch structuralModel.model {
        case .beam:
            break
        case .plate:
            break
        case .solid:
            let homSolidResult = HomSolidResult(typeOfAnalysis: typeOfAnalysis, effectiveSolidStiffness: effectiveSolidStiffness, engineeringConstants: engineeringConstants, thermalCoefficients: thermalCoefficients)
            homResultController.homSolidResult = homSolidResult
        }
        navigationController?.pushViewController(homResultController, animated: true)
    }
}
