//
//  AboutModel.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class GeneralModel {
    let name: String
    let image: UIImage

    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}

class GeneralModels {
    var infoModels: [GeneralModel]
    var helpModels: [GeneralModel]
    var feedbackModel: [GeneralModel]
    var rateModel: [GeneralModel]

    init() {
        let info1 = GeneralModel(name: "About", image: UIImage(named: "info")!)
        let info2 = GeneralModel(name: "Help", image: UIImage(named: "question")!)

        let help1 = GeneralModel(name: "Theory", image: UIImage(named: "theory")!)
        let help2 = GeneralModel(name: "User Manual", image: UIImage(named: "manual")!)

        let feedback = GeneralModel(name: "Feedback", image: UIImage(named: "feedback")!)

        let rate = GeneralModel(name: "Rate This App", image: UIImage(named: "rate")!)

        infoModels = [info1, info2]
        helpModels = [help1, help2]
        feedbackModel = [feedback]
        rateModel = [rate]
    }
}
