//
//  ExplainPopovers.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 3/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

func stackingSequenceExplainPopover() -> UIViewController {
    
    let viewController = UIViewController()
    
    viewController.modalPresentationStyle = UIModalPresentationStyle.popover
    viewController.preferredContentSize = CGSize(width: 300, height: 300)

    let explainUIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    viewController.view.addSubview(explainUIView)

    let explainLabel1 = UILabel()

    explainUIView.addSubview(explainLabel1)

    explainLabel1.translatesAutoresizingMaskIntoConstraints = false
    explainLabel1.text = "Definition"
    explainLabel1.textAlignment = .center
    explainLabel1.font = UIFont.boldSystemFont(ofSize: 15)

    explainLabel1.heightAnchor.constraint(equalToConstant: 20).isActive = true
    explainLabel1.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
    explainLabel1.topAnchor.constraint(equalTo: explainUIView.topAnchor, constant: 8).isActive = true

    let explainLabel2 = UILabel()

    explainUIView.addSubview(explainLabel2)

    explainLabel2.translatesAutoresizingMaskIntoConstraints = false
    explainLabel2.text = "The layup angles from the bottom surface to the top surface."
    explainLabel2.numberOfLines = -1
    explainLabel2.font = UIFont.systemFont(ofSize: 14)

    explainLabel2.heightAnchor.constraint(equalToConstant: 36).isActive = true
    explainLabel2.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
    explainLabel2.topAnchor.constraint(equalTo: explainLabel1.bottomAnchor, constant: 0).isActive = true
    explainLabel2.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true

    let explainLabel3 = UILabel()

    explainUIView.addSubview(explainLabel3)

    explainLabel3.translatesAutoresizingMaskIntoConstraints = false
    explainLabel3.text = "Format"
    explainLabel3.textAlignment = .center
    explainLabel3.font = UIFont.boldSystemFont(ofSize: 15)

    explainLabel3.heightAnchor.constraint(equalToConstant: 20).isActive = true
    explainLabel3.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
    explainLabel3.topAnchor.constraint(equalTo: explainLabel2.bottomAnchor, constant: 8).isActive = true

    let explainLabel4 = UILabel()

    explainUIView.addSubview(explainLabel4)

    explainLabel4.translatesAutoresizingMaskIntoConstraints = false
    explainLabel4.text = "[xx/xx/xx/xx/..]msn\nxx: Layup angle\nm: Number of repetition before symmetry\ns: Symmetry or not\nn: Number of repetition after symmetry"
    explainLabel4.numberOfLines = -1
    explainLabel4.font = UIFont.systemFont(ofSize: 14)

    explainLabel4.heightAnchor.constraint(equalToConstant: 18*5).isActive = true
    explainLabel4.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
    explainLabel4.topAnchor.constraint(equalTo: explainLabel3.bottomAnchor, constant: 0).isActive = true
    explainLabel4.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true


    let explainLabel5 = UILabel()

    explainUIView.addSubview(explainLabel5)

    explainLabel5.translatesAutoresizingMaskIntoConstraints = false
    explainLabel5.text = "Examples"
    explainLabel5.textAlignment = .center
    explainLabel5.font = UIFont.boldSystemFont(ofSize: 15)

    explainLabel5.heightAnchor.constraint(equalToConstant: 20).isActive = true
    explainLabel5.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 1.0) .isActive = true
    explainLabel5.topAnchor.constraint(equalTo: explainLabel4.bottomAnchor, constant: 8).isActive = true


    let explainLabel6 = UILabel()

    explainUIView.addSubview(explainLabel6)

    explainLabel6.translatesAutoresizingMaskIntoConstraints = false
    explainLabel6.text = "Cross-ply laminates: [0/90]\nBalanced laminates: [45/-45]\n[0/90]2 : [0/90/0/90]\n[0/90]s : [0/90/90/0]"
    explainLabel6.numberOfLines = -1
    explainLabel6.font = UIFont.systemFont(ofSize: 14)

    explainLabel6.heightAnchor.constraint(equalToConstant: 18*4).isActive = true
    explainLabel6.widthAnchor.constraint(equalTo: explainUIView.widthAnchor, multiplier: 0.9) .isActive = true
    explainLabel6.topAnchor.constraint(equalTo: explainLabel5.bottomAnchor, constant: 0).isActive = true
    explainLabel6.centerXAnchor.constraint(equalTo: explainUIView.centerXAnchor).isActive = true
    
    return viewController
}
