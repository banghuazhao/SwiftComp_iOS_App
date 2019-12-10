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
