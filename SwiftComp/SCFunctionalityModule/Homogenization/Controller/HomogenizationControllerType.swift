//
//  HomogenizationControllerType.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 11/17/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

import SVProgressHUD

protocol HomogenizationControllerType {
    var method: Method { get set }
    var structuralModel: StructuralModel { get set }
    var typeOfAnalysis: TypeOfAnalysis { get set }
}

extension HomogenizationControllerType where Self: UIViewController {
    var tablewViewFooterHeight: CGFloat {
        return 72
    }

    func setupKeyboard() {
        #if !targetEnvironment(macCatalyst)
            hideKeyboardWhenTappedAround()
        #endif
    }
    
    func showSavedHuD() {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize(width: 128, height: 64))
        SVProgressHUD.showSuccess(withStatus: "Saved")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }

    func showCalculationHUD() {
        SVProgressHUD.addTapDismissGuesture()
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumSize(CGSize(width: 196, height: 164))
        SVProgressHUD.show(withStatus: "Calculating\n\nTap to Cancel")
    }

    func showCalculationSuccessHUD(completion: SVProgressHUDDismissCompletion?) {
        SVProgressHUD.showSuccess(withStatus: "Success")
        SVProgressHUD.dismiss(withDelay: 0.6, completion: completion)
    }

    var isCalculationCancelled: Bool {
        return !SVProgressHUD.isVisible()
    }

    func dismissHUD() {
        SVProgressHUD.dismiss()
    }

    func showCalculationErrorHUD() {
        SVProgressHUD.showError(withStatus: "Calculation Error")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }

    func showNetworkErrorHUD() {
        SVProgressHUD.showError(withStatus: "Network Error")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
}

extension SVProgressHUD {
    public static func addTapDismissGuesture() {
        let nc = NotificationCenter.default
        nc.addObserver(
            self, selector: #selector(hudTapped(_:)),
            name: NSNotification.Name.SVProgressHUDDidTouchDownInside,
            object: nil
        )
        nc.addObserver(
            self, selector: #selector(hudDisappeared(_:)),
            name: NSNotification.Name.SVProgressHUDWillDisappear,
            object: nil
        )
    }

    @objc private static func hudTapped(_ notification: Notification) {
        SVProgressHUD.dismiss()
    }

    @objc private static func hudDisappeared(_ notification: Notification) {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent, object: nil)
        nc.removeObserver(self, name: NSNotification.Name.SVProgressHUDWillDisappear, object: nil)
    }
}
