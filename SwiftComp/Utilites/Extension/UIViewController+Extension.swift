//
//  UIViewController+Extension.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 12/10/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

// MARK: - setupCancelButton

extension UIViewController {
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
    }

    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - hideKeyboardWhenTappedAround

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
