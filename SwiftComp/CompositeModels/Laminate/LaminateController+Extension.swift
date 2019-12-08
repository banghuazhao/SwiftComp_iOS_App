//
//  LaminateController+Extension.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/5/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Accelerate
import UIKit

extension LaminateController {
    // MARK: nonSwiftCompCalculate

    func CLPTCalculate() {
        // plate model result
        var effectivePlateStiffness: [String: String] = [:]
        var inPlaneProperties: [String: String] = [:]
        var flexuralProperties: [String: String] = [:]

        // solid model result
        var effectiveSolidStiffness: [String: String] = [:]
        var engineeringConstants: [String: String] = [:]

        // thermal result
        var thermalCoefficients: [String: String]?

        let layupSequence = stackingSequence.stackingSequence ?? [0.0]
        let nPly = layupSequence.count
        var layerThickness = stackingSequence.layerThickness ?? 1.0

        var bzi = [Double]()
        for i in 1 ... nPly {
            let bz = (-Double(nPly + 1) * layerThickness) / 2 + Double(i) * layerThickness
            bzi.append(bz)
        }

        var Cp: [Double] = []
        var Qep: [Double] = []

        var (e1, e2, e3, g12, g13, g23, nu12, nu13, nu23) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var (c11, c12, c13, c14, c15, c16, c22, c23, c24, c25, c26, c33, c34, c35, c36, c44, c45, c46, c55, c56, c66) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var (alpha11, alpha22, alpha33, alpha23, alpha13, alpha12) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        let laminaMaterial = laminaMaterials.selectedMaterial

        switch laminaMaterial.materialType {
        case .transverselyIsotropic:
            e1 = laminaMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            e2 = laminaMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            g12 = laminaMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            nu12 = laminaMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            nu23 = laminaMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            e3 = e2
            g13 = g12
            g23 = e2 / (2 * (1 + nu23))
            nu13 = nu12

            if laminaMaterial.analysisType == .thermoElastic {
                alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alpha33 = alpha22
                alpha23 = 0
                alpha13 = 0
                alpha12 = 0
            }
        case .orthotropic:
            e1 = laminaMaterial.materialProperties.first(where: { $0.name == .E1 })?.value ?? 0
            e2 = laminaMaterial.materialProperties.first(where: { $0.name == .E2 })?.value ?? 0
            e3 = laminaMaterial.materialProperties.first(where: { $0.name == .E3 })?.value ?? 0
            g12 = laminaMaterial.materialProperties.first(where: { $0.name == .G12 })?.value ?? 0
            g13 = laminaMaterial.materialProperties.first(where: { $0.name == .G13 })?.value ?? 0
            g23 = laminaMaterial.materialProperties.first(where: { $0.name == .G23 })?.value ?? 0
            nu12 = laminaMaterial.materialProperties.first(where: { $0.name == .nu12 })?.value ?? 0
            nu13 = laminaMaterial.materialProperties.first(where: { $0.name == .nu13 })?.value ?? 0
            nu23 = laminaMaterial.materialProperties.first(where: { $0.name == .nu23 })?.value ?? 0
            if laminaMaterial.analysisType == .thermoElastic {
                alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alpha33 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                alpha23 = 0
                alpha13 = 0
                alpha12 = 0
            }
        case .anisotropic:
            c11 = laminaMaterial.materialProperties.first(where: { $0.name == .C11 })?.value ?? 0
            c12 = laminaMaterial.materialProperties.first(where: { $0.name == .C12 })?.value ?? 0
            c13 = laminaMaterial.materialProperties.first(where: { $0.name == .C13 })?.value ?? 0
            c14 = laminaMaterial.materialProperties.first(where: { $0.name == .C14 })?.value ?? 0
            c15 = laminaMaterial.materialProperties.first(where: { $0.name == .C15 })?.value ?? 0
            c16 = laminaMaterial.materialProperties.first(where: { $0.name == .C16 })?.value ?? 0
            c22 = laminaMaterial.materialProperties.first(where: { $0.name == .C22 })?.value ?? 0
            c23 = laminaMaterial.materialProperties.first(where: { $0.name == .C23 })?.value ?? 0
            c24 = laminaMaterial.materialProperties.first(where: { $0.name == .C24 })?.value ?? 0
            c25 = laminaMaterial.materialProperties.first(where: { $0.name == .C25 })?.value ?? 0
            c26 = laminaMaterial.materialProperties.first(where: { $0.name == .C26 })?.value ?? 0
            c33 = laminaMaterial.materialProperties.first(where: { $0.name == .C33 })?.value ?? 0
            c34 = laminaMaterial.materialProperties.first(where: { $0.name == .C34 })?.value ?? 0
            c35 = laminaMaterial.materialProperties.first(where: { $0.name == .C35 })?.value ?? 0
            c36 = laminaMaterial.materialProperties.first(where: { $0.name == .C36 })?.value ?? 0
            c44 = laminaMaterial.materialProperties.first(where: { $0.name == .C44 })?.value ?? 0
            c45 = laminaMaterial.materialProperties.first(where: { $0.name == .C45 })?.value ?? 0
            c46 = laminaMaterial.materialProperties.first(where: { $0.name == .C46 })?.value ?? 0
            c55 = laminaMaterial.materialProperties.first(where: { $0.name == .C55 })?.value ?? 0
            c56 = laminaMaterial.materialProperties.first(where: { $0.name == .C56 })?.value ?? 0
            c66 = laminaMaterial.materialProperties.first(where: { $0.name == .C66 })?.value ?? 0
            if laminaMaterial.analysisType == .thermoElastic {
                alpha11 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha11 })?.value ?? 0
                alpha22 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha22 })?.value ?? 0
                alpha33 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha33 })?.value ?? 0
                alpha23 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha23 })?.value ?? 0
                alpha13 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha13 })?.value ?? 0
                alpha12 = laminaMaterial.materialProperties.first(where: { $0.name == .alpha12 })?.value ?? 0
            }
        default:
            break
        }

        if laminaMaterial.materialType != .anisotropic(.elastic) && laminaMaterial.materialType != .anisotropic(.thermoElastic) {
            let Sp: [Double] = [1 / e1, -nu12 / e1, -nu13 / e1, 0, 0, 0, -nu12 / e1, 1 / e2, -nu23 / e2, 0, 0, 0, -nu13 / e1, -nu23 / e2, 1 / e3, 0, 0, 0, 0, 0, 0, 1 / g23, 0, 0, 0, 0, 0, 0, 1 / g13, 0, 0, 0, 0, 0, 0, 1 / g12]
            Cp = invert(matrix: Sp)
            let Sep: [Double] = [1 / e1, -nu12 / e1, 0, -nu12 / e1, 1 / e2, 0, 0, 0, 1 / g12]
            Qep = invert(matrix: Sep)

        } else {
            Cp = [c11, c12, c13, c14, c15, c16, c12, c22, c23, c24, c25, c26, c13, c23, c33, c34, c35, c36, c14, c24, c34, c44, c45, c46, c15, c25, c35, c45, c55, c56, c16, c26, c36, c46, c56, c66]
            Qep = [c11, c12, c16, c12, c22, c26, c16, c26, c66]
        }

        var tempCts = [Double](repeating: 0.0, count: 9)
        var tempCets = [Double](repeating: 0.0, count: 9)
        var Qs = [Double](repeating: 0.0, count: 9)
        var Cts = [Double](repeating: 0.0, count: 9)
        var Cets = [Double](repeating: 0.0, count: 9)
        var Ces = [Double](repeating: 0.0, count: 9)

        // Calculate effective 3D properties
        for i in 1 ... nPly {
            // Set up
            let c = cos(layupSequence[i - 1] * Double.pi / 180)
            let s = sin(layupSequence[i - 1] * Double.pi / 180)
            let Rsigma = [c * c, s * s, 0, 0, 0, -2 * s * c, s * s, c * c, 0, 0, 0, 2 * s * c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0, 0, 0, -s, c, 0, s * c, -s * c, 0, 0, 0, c * c - s * s]
            var RsigmaT = [Double](repeating: 0.0, count: 36)
            vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)

            var C = [Double](repeating: 0.0, count: 36)
            var temp1 = [Double](repeating: 0.0, count: 36)
            vDSP_mmulD(Rsigma, 1, Cp, 1, &temp1, 1, 6, 6, 6)
            vDSP_mmulD(temp1, 1, RsigmaT, 1, &C, 1, 6, 6, 6)

            // Get Ce, Cet, Ct
            let Ce = [C[0], C[1], C[5], C[1], C[7], C[11], C[5], C[11], C[35]]
            let Cet = [C[2], C[3], C[4], C[8], C[9], C[10], C[17], C[23], C[29]]
            let Ct = [C[14], C[15], C[16], C[15], C[21], C[22], C[16], C[22], C[28]]

            // Get Q
            var Q = [Double](repeating: 0.0, count: 9)
            let CtI = invert(matrix: Ct)
            var CetT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Cet, 1, &CetT, 1, 3, 3)

            var temp2 = [Double](repeating: 0.0, count: 9)
            var temp3 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cet, 1, CtI, 1, &temp2, 1, 3, 3, 3)
            vDSP_mmulD(temp2, 1, CetT, 1, &temp3, 1, 3, 3, 3)
            vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)

            // Get tempCts, Qs, tempCets
            vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
            vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
            var temp4 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cet, 1, CtI, 1, &temp4, 1, 3, 3, 3)
            vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)
        }

        // Get average tempCts, Qs, tempCets
        var nPlyD = Double(nPly)
        vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
        vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
        vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)

        // Get Cts, Cets, Cet
        Cts = invert(matrix: tempCts)
        vDSP_mmulD(tempCets, 1, Cts, 1, &Cets, 1, 3, 3, 3)
        let CtsI = invert(matrix: Cts)
        var CetsT = [Double](repeating: 0.0, count: 9)
        vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
        var temp7 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(Cets, 1, CtsI, 1, &temp7, 1, 3, 3, 3)
        var temp8 = [Double](repeating: 0.0, count: 9)
        vDSP_mmulD(temp7, 1, CetsT, 1, &temp8, 1, 3, 3, 3)
        vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)

        // Get Cs
        let Cs = [Ces[0], Ces[1], Cets[0], Cets[1], Cets[2], Ces[2], Ces[3], Ces[4], Cets[3], Cets[4], Cets[5], Ces[5], Cets[0], Cets[3], Cts[0], Cts[1], Cts[2], Cets[6], Cets[1], Cets[4], Cts[1], Cts[4], Cts[7], Cets[7], Cets[2], Cets[5], Cts[2], Cts[5], Cts[8], Cets[8], Ces[6], Ces[7], Cets[6], Cets[7], Cets[8], Ces[8]]

        let Ss = invert(matrix: Cs)

        // effective solid stiffness

        effectiveSolidStiffness["C11"] = String(Cs[0])
        effectiveSolidStiffness["C12"] = String(Cs[1])
        effectiveSolidStiffness["C13"] = String(Cs[2])
        effectiveSolidStiffness["C14"] = String(Cs[3])
        effectiveSolidStiffness["C15"] = String(Cs[4])
        effectiveSolidStiffness["C16"] = String(Cs[5])

        effectiveSolidStiffness["C21"] = String(Cs[6])
        effectiveSolidStiffness["C22"] = String(Cs[7])
        effectiveSolidStiffness["C23"] = String(Cs[8])
        effectiveSolidStiffness["C24"] = String(Cs[9])
        effectiveSolidStiffness["C25"] = String(Cs[10])
        effectiveSolidStiffness["C26"] = String(Cs[11])

        effectiveSolidStiffness["C31"] = String(Cs[12])
        effectiveSolidStiffness["C32"] = String(Cs[13])
        effectiveSolidStiffness["C33"] = String(Cs[14])
        effectiveSolidStiffness["C34"] = String(Cs[15])
        effectiveSolidStiffness["C35"] = String(Cs[16])
        effectiveSolidStiffness["C36"] = String(Cs[17])

        effectiveSolidStiffness["C41"] = String(Cs[18])
        effectiveSolidStiffness["C42"] = String(Cs[19])
        effectiveSolidStiffness["C43"] = String(Cs[20])
        effectiveSolidStiffness["C44"] = String(Cs[21])
        effectiveSolidStiffness["C45"] = String(Cs[22])
        effectiveSolidStiffness["C46"] = String(Cs[23])

        effectiveSolidStiffness["C51"] = String(Cs[24])
        effectiveSolidStiffness["C52"] = String(Cs[25])
        effectiveSolidStiffness["C53"] = String(Cs[26])
        effectiveSolidStiffness["C54"] = String(Cs[27])
        effectiveSolidStiffness["C55"] = String(Cs[28])
        effectiveSolidStiffness["C56"] = String(Cs[29])

        effectiveSolidStiffness["C61"] = String(Cs[30])
        effectiveSolidStiffness["C62"] = String(Cs[31])
        effectiveSolidStiffness["C63"] = String(Cs[32])
        effectiveSolidStiffness["C64"] = String(Cs[33])
        effectiveSolidStiffness["C65"] = String(Cs[34])
        effectiveSolidStiffness["C66"] = String(Cs[35])

        // engineering constants

        engineeringConstants["E1"] = String(1 / Ss[0])
        engineeringConstants["E2"] = String(1 / Ss[7])
        engineeringConstants["E3"] = String(1 / Ss[14])
        engineeringConstants["G12"] = String(1 / Ss[35])
        engineeringConstants["G13"] = String(1 / Ss[28])
        engineeringConstants["G23"] = String(1 / Ss[21])
        engineeringConstants["nu12"] = String(-1 / Ss[0] * Ss[1])
        engineeringConstants["nu13"] = String(-1 / Ss[0] * Ss[2])
        engineeringConstants["nu23"] = String(-1 / Ss[7] * Ss[8])

        // Calculate A, B, and D matrices

        var A = [Double](repeating: 0.0, count: 9)
        var B = [Double](repeating: 0.0, count: 9)
        var D = [Double](repeating: 0.0, count: 9)

        for i in 1 ... nPly {
            let c = cos(layupSequence[i - 1] * Double.pi / 180)
            let s = sin(layupSequence[i - 1] * Double.pi / 180)
            let Rsigmae = [c * c, s * s, -2 * s * c, s * s, c * c, 2 * s * c, s * c, -s * c, c * c - s * s]
            var RsigmaeT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Rsigmae, 1, &RsigmaeT, 1, 3, 3)

            var Qe = [Double](repeating: 0.0, count: 9)
            var Atemp = [Double](repeating: 0.0, count: 9)
            var Btemp = [Double](repeating: 0.0, count: 9)
            var Dtemp = [Double](repeating: 0.0, count: 9)

            var temp1 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Rsigmae, 1, Qep, 1, &temp1, 1, 3, 3, 3)
            vDSP_mmulD(temp1, 1, RsigmaeT, 1, &Qe, 1, 3, 3, 3)

            vDSP_vsmulD(Qe, 1, &layerThickness, &Atemp, 1, 9)

            var temp2 = bzi[i - 1] * layerThickness
            vDSP_vsmulD(Qe, 1, &temp2, &Btemp, 1, 9)

            var temp3 = layerThickness * bzi[i - 1] * bzi[i - 1] + pow(layerThickness, 3.0) / 12
            vDSP_vsmulD(Qe, 1, &temp3, &Dtemp, 1, 9)

            vDSP_vaddD(A, 1, Atemp, 1, &A, 1, 9)
            vDSP_vaddD(B, 1, Btemp, 1, &B, 1, 9)
            vDSP_vaddD(D, 1, Dtemp, 1, &D, 1, 9)
        }

        let ABD = [A[0], A[1], A[2], B[0], B[1], B[2], A[3], A[4], A[5], B[3], B[4], B[5], A[6], A[7], A[8], B[6], B[7], B[8], B[0], B[3], B[6], D[0], D[1], D[2], B[1], B[4], B[7], D[3], D[4], D[5], B[2], B[5], B[8], D[6], D[7], D[8]]

        let abd = invert(matrix: ABD)

        var h = nPlyD * layerThickness

        let AI = [abd[0], abd[1], abd[2], abd[6], abd[7], abd[8], abd[12], abd[13], abd[14]]

        let DI = [abd[21], abd[22], abd[23], abd[27], abd[28], abd[29], abd[33], abd[34], abd[35]]

        var Ses = [Double](repeating: 0.0, count: 9)
        vDSP_vsmulD(AI, 1, &h, &Ses, 1, 9)

        var Sesf = [Double](repeating: 0.0, count: 9)
        var temph = pow(h, 3.0) / 12.0
        vDSP_vsmulD(DI, 1, &temph, &Sesf, 1, 9)

        effectivePlateStiffness["A11"] = String(A[0])
        effectivePlateStiffness["A12"] = String(A[1])
        effectivePlateStiffness["A16"] = String(A[2])
        effectivePlateStiffness["A22"] = String(A[4])
        effectivePlateStiffness["A26"] = String(A[5])
        effectivePlateStiffness["A66"] = String(A[8])

        effectivePlateStiffness["B11"] = String(B[0])
        effectivePlateStiffness["B12"] = String(B[1])
        effectivePlateStiffness["B16"] = String(B[2])
        effectivePlateStiffness["B22"] = String(B[4])
        effectivePlateStiffness["B26"] = String(B[5])
        effectivePlateStiffness["B66"] = String(B[8])

        effectivePlateStiffness["D11"] = String(D[0])
        effectivePlateStiffness["D12"] = String(D[1])
        effectivePlateStiffness["D16"] = String(D[2])
        effectivePlateStiffness["D22"] = String(D[4])
        effectivePlateStiffness["D26"] = String(D[5])
        effectivePlateStiffness["D66"] = String(D[8])

        inPlaneProperties["E1"] = String(1 / Ses[0])
        inPlaneProperties["E2"] = String(1 / Ses[4])
        inPlaneProperties["G12"] = String(1 / Ses[8])
        inPlaneProperties["nu12"] = String(-1 / Ses[0] * Ses[1])
        inPlaneProperties["eta121"] = String(1 / Ses[8] * Ses[2])
        inPlaneProperties["eta122"] = String(1 / Ses[8] * Ses[5])

        flexuralProperties["E1"] = String(1 / Sesf[0])
        flexuralProperties["E2"] = String(1 / Sesf[4])
        flexuralProperties["G12"] = String(1 / Sesf[8])
        flexuralProperties["nu12"] = String(-1 / Sesf[0] * Sesf[1])
        flexuralProperties["eta121"] = String(1 / Sesf[8] * Sesf[2])
        flexuralProperties["eta122"] = String(1 / Sesf[8] * Sesf[5])

        if typeOfAnalysis == .thermoElastic {
            let alphap: [Double] = [alpha11, alpha22, alpha33, alpha23, alpha13, alpha12]

            var tempalphaes = [Double](repeating: 0.0, count: 3)
            var tempalphats = [Double](repeating: 0.0, count: 3)

            var tempCts = [Double](repeating: 0.0, count: 9)
            var tempCets = [Double](repeating: 0.0, count: 9)
            var Qs = [Double](repeating: 0.0, count: 9)
            var Cts = [Double](repeating: 0.0, count: 9)
            var Cets = [Double](repeating: 0.0, count: 9)
            var Ces = [Double](repeating: 0.0, count: 9)

            // Calculate effective 3D properties
            for i in 1 ... nPly {
                // Set up
                let c = cos(layupSequence[i - 1] * Double.pi / 180)
                let s = sin(layupSequence[i - 1] * Double.pi / 180)
                let Rsigma = [c * c, s * s, 0, 0, 0, -2 * s * c, s * s, c * c, 0, 0, 0, 2 * s * c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0, 0, 0, -s, c, 0, s * c, -s * c, 0, 0, 0, c * c - s * s]
                var RsigmaT = [Double](repeating: 0.0, count: 36)
                vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)
                let Repsilon = invert(matrix: RsigmaT)

                var C = [Double](repeating: 0.0, count: 36)
                var temp1 = [Double](repeating: 0.0, count: 36)
                vDSP_mmulD(Rsigma, 1, Cp, 1, &temp1, 1, 6, 6, 6)
                vDSP_mmulD(temp1, 1, RsigmaT, 1, &C, 1, 6, 6, 6)

                // Get Ce, Cet, Ct
                let Ce = [C[0], C[1], C[5], C[1], C[7], C[11], C[5], C[11], C[35]]
                let Cet = [C[2], C[3], C[4], C[8], C[9], C[10], C[17], C[23], C[29]]
                let Ct = [C[14], C[15], C[16], C[15], C[21], C[22], C[16], C[22], C[28]]

                // Get Q
                var Q = [Double](repeating: 0.0, count: 9)
                let CtI = invert(matrix: Ct)
                var CetT = [Double](repeating: 0.0, count: 9)
                vDSP_mtransD(Cet, 1, &CetT, 1, 3, 3)

                var temp2 = [Double](repeating: 0.0, count: 9)
                var temp3 = [Double](repeating: 0.0, count: 9)
                vDSP_mmulD(Cet, 1, CtI, 1, &temp2, 1, 3, 3, 3)
                vDSP_mmulD(temp2, 1, CetT, 1, &temp3, 1, 3, 3, 3)
                vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)

                // Get tempCts, Qs, tempCets
                vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
                vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
                var temp4 = [Double](repeating: 0.0, count: 9)
                vDSP_mmulD(Cet, 1, CtI, 1, &temp4, 1, 3, 3, 3)
                vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)

                // Get alphaes

                var alpha = [Double](repeating: 0.0, count: 6)
                vDSP_mmulD(Repsilon, 1, alphap, 1, &alpha, 1, 6, 1, 6)

                let alphae = [alpha[0], alpha[1], alpha[5]]
                let alphat = [alpha[2], alpha[3], alpha[4]]

                // Get tempalphate, tempalphats
                var temp5 = [Double](repeating: 0.0, count: 3)
                vDSP_mmulD(Q, 1, alphae, 1, &temp5, 1, 3, 1, 3)
                vDSP_vaddD(tempalphaes, 1, temp5, 1, &tempalphaes, 1, 3)

                vDSP_mmulD(CtI, 1, CetT, 1, &temp2, 1, 3, 3, 3)
                vDSP_mmulD(temp2, 1, alphae, 1, &temp5, 1, 3, 1, 3)

                var temp6 = [Double](repeating: 0.0, count: 3)
                vDSP_vaddD(alphat, 1, temp5, 1, &temp6, 1, 3)
                vDSP_vaddD(tempalphats, 1, temp6, 1, &tempalphats, 1, 3)
            }

            // Get average tempCts, Qs, tempCets
            var nPlyD = Double(nPly)
            vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
            vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
            vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)

            // Get Cts, Cets, Cet
            Cts = invert(matrix: tempCts)
            vDSP_mmulD(tempCets, 1, Cts, 1, &Cets, 1, 3, 3, 3)
            let CtsI = invert(matrix: Cts)
            var CetsT = [Double](repeating: 0.0, count: 9)
            vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
            var temp7 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(Cets, 1, CtsI, 1, &temp7, 1, 3, 3, 3)
            var temp8 = [Double](repeating: 0.0, count: 9)
            vDSP_mmulD(temp7, 1, CetsT, 1, &temp8, 1, 3, 3, 3)
            vDSP_vaddD(Qs, 1, temp8, 1, &Ces, 1, 9)

            // Get alphaes, alphats
            vDSP_vsdivD(tempalphaes, 1, &nPlyD, &tempalphaes, 1, 3)
            vDSP_vsdivD(tempalphats, 1, &nPlyD, &tempalphats, 1, 3)

            let QsI = invert(matrix: Qs)
            var alphaes = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(QsI, 1, tempalphaes, 1, &alphaes, 1, 3, 1, 3)

            var alphats = [Double](repeating: 0.0, count: 3)
            var temp9 = [Double](repeating: 0.0, count: 9)
            var temp10 = [Double](repeating: 0.0, count: 3)
            vDSP_mmulD(CtsI, 1, CetsT, 1, &temp9, 1, 3, 3, 3)
            vDSP_mmulD(temp9, 1, alphaes, 1, &temp10, 1, 3, 1, 3)
            vDSP_vsubD(temp10, 1, tempalphats, 1, &alphats, 1, 3)

            thermalCoefficients = [:]
            thermalCoefficients!["alpha11"] = String(alphaes[0])
            thermalCoefficients!["alpha22"] = String(alphaes[1])
            thermalCoefficients!["alpha33"] = String(alphats[0])
            thermalCoefficients!["alpha23"] = String(alphats[1] / 2)
            thermalCoefficients!["alpha13"] = String(alphats[2] / 2)
            thermalCoefficients!["alpha12"] = String(alphaes[2] / 2)
        }

        // MARK: - push result controller

        let homResultController = HomResultController()
        switch structuralModel.model {
        case .beam:
            break
        case .plate:
            let homPlateResult = HomPlateResult(typeOfAnalysis: typeOfAnalysis, structuralModel: structuralModel, effectivePlateStiffness: effectivePlateStiffness, inPlaneProperties: inPlaneProperties, flexuralProperties: flexuralProperties, thermalCoefficients: thermalCoefficients)
            homResultController.homPlateResult = homPlateResult
        case .solid:
            let homSolidResult = HomSolidResult(typeOfAnalysis: typeOfAnalysis, effectiveSolidStiffness: effectiveSolidStiffness, engineeringConstants: engineeringConstants, thermalCoefficients: thermalCoefficients)
            homResultController.homSolidResult = homSolidResult
        }
        navigationController?.pushViewController(homResultController, animated: true)
    }
}
