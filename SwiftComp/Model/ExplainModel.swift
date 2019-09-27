//
//  ExplainModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/21/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation


struct ExplainModel {
    
    // MARK: general
    
    let methodExplain = """
        • SwiftComp:
        General-purpose computational approach for constitutive modeling of composite materials.
        """
    
    let structureModel = """
        A structure can be modeled by beam, plate, or solid.

        • Beam Model:
        The structure is modeled as a beam. The results will give beam stiffness matrix, which can be used for beam element.

        • Plate Model:
        The structure modeled as a plate. The results will give A, B, D matrices, in-plane properties and flexural properties, which can be used for plate element.

        • Solid Model:
        The structure is modeled as a solid. The results will give solid stiffness matrix and engineering constants, which can be used for brick element.

        Note, 1D SG can't be modeled as beam model.
        """
    
    let plateSubmodel = """
        For plate model of SwiftComp, two submodel are available:

        • Kirchho-Love Model:
        Classical plate model for flat panels based on a set of ad hoc assumptions including the thickness being rigid in the thickness direction, perpendicular to the reference surface, and plane stress assumption. The result will give A, B, and D matrices

        • Reissner-Mindlin Model:
        The refined model for the plate when the thickness of the panel is not very small with respect to the in-plane dimensions. The result will give A, B, and D matrices and transversely sheasr stiffenss matrix.
        """
    
    let plateInitialCurvatures = """
        k12 and k21 are defined as the initial curvatures of the plate so that the plate is modeled as a shell.

        If the structure is initially straight, zeroes should be provided instead.
        """
    
    let beameSubmodel = """
        For beam model of SwiftComp, two submodel are available:

        • Euler-Bernoulli Model:
        Euler-Bernoulli model was originally developed based on a set of ad hoc assumptions including the cross section being rigid in plane, perpendicular to the reference line, and uniaxial stress assumption. The result of give 4 by 4 beam stiffenss matrix.

        • Timoshenko Model:
        The refined model for the plate when the thickness of the panel is not very small with respect to the in-plane dimensions. The result of give 6 by 6 beam stiffenss matrix.
        """
    
    let beamInitialTwistCurvatures = """
        k11, k12, and k13 are defined as the initial twist(k11) and curvatures (k12, k13) of the beam.

        If the structure is initially straight, zeroes should be provided instead.
        """
    
    let beamObliqueCrossSections = """
        cos(angle1) and cos(angle2) are two real numbers to specify a SG with oblique cross-sections.

        The first number is cosine of the angle between normal of the oblique section (y1) and beam axis x1. The second number is cosine of the angle between y2 of the oblique section and beam axis (x1).

        The summation of the square of these two numbers should not be greater than 1.0 in double precision. The inputs including coordinates, material properties, etc. and the outputs including mass matrix, stiness matrix, etc. are given in the oblique system, the yi coordinate system. For normal cross-sections, we provide 1.0 0.0 on this line instead.
        """
    
    let typeOfAnalysisExplainText = """
        • Elastic Analysis:
        You need to provide elastic properites to do the analysis. The elastic properties are Young's modulus, shear modlulus, Poisson's ratio, or elastic constants (Cij).
        
        • Thermoelastic Analysis:
        In addtional to elastic properties, you also need to provide CTEs (Coefficient of Thermal Expansion) to do the analysis.
        """
    
    let materialExplain = """
        • Isotropic Material:
        You need to procide E, nu. (Thermoelastic Analysis: alpha11)

        • Transversely Material:
        You need to procide E1, E2, G12, nu12, nu23. (Thermoelastic Analysis: alpha11, alpha22)

        • Orthotropic Material:
        You need to procide E1, E2, E3, G12, G13, G23, nu12, nu13, nu23. (Thermoelastic Analysis: alpha11, alpha22, alpha33)

        • Anisotropic Material:
        You need to procide C11, C12, C13, C14, C15, C16, C22, C23, C24, C25, C26, C33, C34, C35, C36, C44, C45, C46, C55, C56, C66. (Thermoelastic Analysis: alpha11, alpha22, alpha33, alpha23, alpha13, alpha12)
        """
    
    
    // laminate
    
    
    let laminateMethodExplain = """
        • Classical Laminated Plate Theory (CLPT):
        1. Straight lines normal to the mid-surface remain straight after deformation
        2. Straight lines normal to the mid-surface remain normal to the mid-surface after deformation
        3. The thickness of the plate does not change during a deformation.
        """
    
    let laminateStructureModel = """
        Since a laminate in this case is a 1D SG, it can be modeled by plate or solid.
        """
    
    
    let laminateGeometryExplain = """
        The geometry of a laminate is defined by stacking sequence.
        
        The stacking sequence is the layup angles from the bottom surface to the top surface.
        
        The format of stacking sequence is [xx/xx/xx/xx/..]msn
        xx: Layup angle
        m: Number of repetition before symmetry
        s: Symmetry or not
        n: Number of repetition after symmetry
        
        • Examples:
        Cross-ply laminates: [0/90]
        Balanced laminates: [45/-45]
        [0/90]2 : [0/90/0/90]
        [0/90]s : [0/90/90/0]
        [30/-30]2s : [30/-30/30/-30/-30/30/-30/30]
        [30/-30]s2 : [30/-30/-30/30/30/-30/-30/30]

        The layer thickness is the thickness for each lamina. Note, it doesn't need layer thickness information for solid model.
        """
    
    let laminateMaterialExplain = """
        For a laminate in this analysis, the material of each lamina (layer) is assumed to be the same.

        Thus, only one lamina material needs to be defined.

        You can define transversely isotropic, orthotropic, or anisotropic material for a lamina.
        """
    
    
    // UDFRC
    
    let UDFRCMethodExplain = """
        • Voigt Rules of Mixture:
        The strain field within the RVE is constant.

        • Reuss Rules of Mixture:
        The strain field within the RVE is constant.

        • Hybrid Rules of Mixture:
        A subset of local stress components (sigma22, sigma33, sigma23, sigma13, sigma12) along with a complementary subset of local strain components (epsilon11) are constant.
        """
    
    let UDFRCStructureModel = """
        A unidirectional fiber reinforced composite (UDFRC) can be modeled by beam, plate, or solid.

        Note, the rules of mixture methos can only do plate or solid model.
        """
    
    
    let UDFRCGeometryExplain = """
        The geometry of the unidirectional fiber reinforced composited is determined by fiber volume fractions.

        The fiber volume fraction is defined as the fiber volume divided by the total volume of the composite:

        fiber volume fraction = fiber volume / total volume of the composite
        """
    
    let UDFRCFiberMaterialExplain = """
        The fiber is the reinforcing phase in a composite. In fiber direction, it is stiff and strong and serves as the main load carrier. The fiber is usually made of carbon or glass.

        You can define fiber material as isotropic, transversely isotropic, or orthotropic.
        """
    
    let UDFRCMatrixMaterialExplain = """
        The matrix is the supporting phase in a composite, which protects the reinforcing phase and transfers the load to the reinforcing phases. The matrix is usually made of Epoxy.

        You can define matrix material as isotropic, transversely isotropic, or orthotropic.
        """
    
    let honeycombSandwichMethodExplain = """
        To analysis honeycomb sandwich structure, the only method available is SwiftComp.
        """
    
    let honeycombSandwichFacesheetGeometryExplain = """
        The top and down facesheets of the honeycomb sandwich are consist of the same Laminate.

        The geometry of a Laminate is defined by stacking sequence and a layer thickness.

        The stacking sequence of the top facesheet is the layup angles from the bottom surface to the top surface.

        The stacking sequence of the bottom facesheet is the layup angles from the top surface to the bottom surface.
        
        The format of stacking sequence is [xx/xx/xx/xx/..]msn
        xx: Layup angle
        m: Number of repetition before symmetry
        s: Symmetry or not
        n: Number of repetition after symmetry
        
        • Examples:
        Cross-ply laminates: [0/90]
        Balanced laminates: [45/-45]
        [0/90]2 : [0/90/0/90]
        [0/90]s : [0/90/90/0]
        [30/-30]2s : [30/-30/30/-30/-30/30/-30/30]
        [30/-30]s2 : [30/-30/-30/30/30/-30/-30/30]

        The layer thickness is the thickness for each lamina.
        """
    
    let honeycombSandwichCoreMaterialExplain = """
        You can define core material as isotropic, transversely isotropic, or orthotropic.
        """
    
    let honeycombSandwichlaminaMaterialExplain = """
        For facesheets in this analysis, the material of each lamina (layer) is assumed to be the same.

        Thus, only one lamina material needs to be defined.

        You can define transversely isotropic, orthotropic, or anisotropic material for a lamina.
        """
    
}
