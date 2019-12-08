//
//  ErrorPopoverRenderer.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 9/19/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

// handle get parameter errors

protocol ErrorPopoverRenderer {
}

// MARK: - analysis setting error

extension ErrorPopoverRenderer where Self: UIViewController {
    func wrongBeamSubmodelParameters() {
        let ac = UIAlertController(title: "Wrong Beam Submodel Parameters", message: "Please double check analysis setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    func wrongPlateSubmodelParameters() {
        let ac = UIAlertController(title: "Wrong Plate/Shell Submodel Parameters", message: "Please double check analysis setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - geometry error

extension ErrorPopoverRenderer where Self: UIViewController {
    
    func wrongStackingSequencePopover() {
        let ac = UIAlertController(title: "Wrong Stacking Sequence", message: "Please double check geometry setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    func tooManyLayersPopover(maxNumOfLayers: Int) {
        let ac = UIAlertController(title: "Too Many Layers", message: "For this composite model, the maximum number of layers is \(maxNumOfLayers)", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    func wrongLayerThicknessPopover() {
        let ac = UIAlertController(title: "Wrong Layer Thickness", message: "Please double check geometry setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    func wrongHoneycombCoreGeometryPopover() {
        let message = """
        Make sure to have:
        2<=l₁/tc<=100
        hc/l₁<=20
        """
        let ac = UIAlertController(title: "Wrong Honeycomb Core Geometry", message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func wrongSquarePackLengthPopover() {
        let ac = UIAlertController(title: "Wrong Square Pack Length", message: "Please double check geometry setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - material error

extension ErrorPopoverRenderer where Self: UIViewController {
    func wrongMaterialPropertiesPopover() {
        let ac = UIAlertController(title: "Wrong Material Properties", message: "Please double check material setting", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - network error

extension ErrorPopoverRenderer where Self: UIViewController {
    func networkErrorPopover() {
        let ac = UIAlertController(title: "Network Error", message: "Please double check the network", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func noNetworkErrorPopover() {
        let ac = UIAlertController(title: "No Network Connection", message: "To run SwiftComp, please connect to internet", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - swiftcomp calculation error

extension ErrorPopoverRenderer where Self: UIViewController {
    func swiftcompCalculationErrorPopover() {
        let ac = UIAlertController(title: "SwiftComp Calculation Failed", message: "Please double check the inputs", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

// MARK: - unknown error

extension ErrorPopoverRenderer where Self: UIViewController {
    func unknownErrorPopover() {
        let ac = UIAlertController(title: "Unknown Error", message: "Please try other composite models", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}

enum swiftcompCalculationError: Error {
    case timeOutError
    case networkError
    case parseJSONError
    case noError
}

enum GetParametersStatus {
    case noError
    case wrongMaterialValue
    case wrongCTEValue
    case wrongNuValue
    case wrongStackingSequence
    case wrongLayerThickness
    case wrongPlateInitialCurvatures
    case wrongBeamInitialTwistCurvatures
    case wrongBeamObliqueCrossSections
    case wrongSquarePackLength
    case wrongCoreGeometryLength
    case tooManyLayers
}

func getParametersErrorHandler(vc: UIViewController, getParaemtersStatus: GetParametersStatus) {
    switch getParaemtersStatus {
    case .wrongMaterialValue:
        let wrongMaterialValue = UIAlertController(title: "Wrong or empty material values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
        wrongMaterialValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongMaterialValue, animated: true, completion: nil)

    case .wrongCTEValue:
        let wrongCTEValue = UIAlertController(title: "Wrong or empty CTE Values", message: "Please double check!", preferredStyle: UIAlertController.Style.alert)
        wrongCTEValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongCTEValue, animated: true, completion: nil)

    case .wrongNuValue:
        let wrongNuValue = UIAlertController(title: "Wrong Poisson's ratio value(s)", message: "Poisson's ratio should not equal to -1", preferredStyle: UIAlertController.Style.alert)
        wrongNuValue.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongNuValue, animated: true, completion: nil)

    case .wrongStackingSequence:
        let wrongStackingSequence = UIAlertController(title: "Wrong or empty stacking sequence", message: "Please double check", preferredStyle: UIAlertController.Style.alert)
        wrongStackingSequence.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongStackingSequence, animated: true, completion: nil)

    case .wrongLayerThickness:
        let wrongLayerThickness = UIAlertController(title: "Wrong, empty, or zero layer thickness", message: """
        Make sure to have:
        layer thickness < hc
        """, preferredStyle: UIAlertController.Style.alert)
        wrongLayerThickness.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongLayerThickness, animated: true, completion: nil)

    case .wrongPlateInitialCurvatures:
        let wrongPlateInitialCurvatures = UIAlertController(title: "Wrong or empty plate initial curvatures", message: "Please double check", preferredStyle: UIAlertController.Style.alert)
        wrongPlateInitialCurvatures.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongPlateInitialCurvatures, animated: true, completion: nil)

    case .wrongBeamInitialTwistCurvatures:
        let wrongBeamInitialTwistCurvatures = UIAlertController(title: "Wrong or empty beam initial twist/curvatures", message: "Please double check", preferredStyle: UIAlertController.Style.alert)
        wrongBeamInitialTwistCurvatures.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongBeamInitialTwistCurvatures, animated: true, completion: nil)

    case .wrongBeamObliqueCrossSections:
        let wrongBeamObliqueCrossSections = UIAlertController(title: "Wrong or empty beam oblique sections", message: "Please double check (Note: cos(angle1) + cos(angle2) <= 1.0", preferredStyle: UIAlertController.Style.alert)
        wrongBeamObliqueCrossSections.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongBeamObliqueCrossSections, animated: true, completion: nil)

    case .wrongSquarePackLength:
        let wrongSquarePackLength = UIAlertController(title: "Wrong, empty, or zero square pack length", message: "Please double check", preferredStyle: UIAlertController.Style.alert)
        wrongSquarePackLength.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongSquarePackLength, animated: true, completion: nil)
    case .wrongCoreGeometryLength:
        let wrongCoreGeometryLength = UIAlertController(title: "Wrong, empty, or zero core geometry", message: """
        Make sure to have:
        2<=l1/tc<=100
        hc/l1<=20
        """, preferredStyle: UIAlertController.Style.alert)
        wrongCoreGeometryLength.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(wrongCoreGeometryLength, animated: true, completion: nil)
    case .tooManyLayers:
        let tooManyLayers = UIAlertController(title: "Too many layers", message: "In this analysis, the maximum number of layers is 6 to ensure computational efficiency", preferredStyle: UIAlertController.Style.alert)
        tooManyLayers.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(tooManyLayers, animated: true, completion: nil)
    default:
        break
    }
}

// handle get parameter errors

func swiftcompCalculationErrorHandler(vc: UIViewController, swiftcompCalculationStatus: swiftcompCalculationStatus) {
    switch swiftcompCalculationStatus {
    case .networkError:

        let networkErrorAlter = UIAlertController(title: "Network error", message: "Please double check you network.", preferredStyle: UIAlertController.Style.alert)
        networkErrorAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(networkErrorAlter, animated: true, completion: nil)

    case .parseJSONError:
        let parseJSONErrorAlter = UIAlertController(title: "Error when fetch data from server", message: "Something is wrong, please report this bug. Thanks!", preferredStyle: UIAlertController.Style.alert)
        parseJSONErrorAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(parseJSONErrorAlter, animated: true, completion: nil)

    case .timeOutError:
        let networkTimeOutErrorAlter = UIAlertController(title: "Network timeout error", message: "Please double check you network.", preferredStyle: UIAlertController.Style.alert)
        networkTimeOutErrorAlter.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(networkTimeOutErrorAlter, animated: true, completion: nil)
    default:
        break
    }
}
