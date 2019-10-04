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
        let info1 = GeneralModel(name: "About", image: UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: UIColor.init(displayP3Red: 48/255, green: 111/255, blue: 227/255, alpha: 1), size: CGSize(width: 30, height: 30)))
        let info2 = GeneralModel(name: "Help", image: UIImage.fontAwesomeIcon(name: .questionCircle, style: .solid, textColor: UIColor.init(displayP3Red: 48/255, green: 111/255, blue: 227/255, alpha: 1), size: CGSize(width: 30, height: 30)))

        let help1 = GeneralModel(name: "Theory", image: UIImage.fontAwesomeIcon(name: .bookOpen, style: .solid, textColor: UIColor.init(displayP3Red: 198/255, green: 96/255, blue: 48/255, alpha: 1), size: CGSize(width: 30, height: 30)))
        let help2 = GeneralModel(name: "User Manual", image: UIImage.fontAwesomeIcon(name: .filePdf, style: .solid, textColor: #colorLiteral(red: 0.9135804772, green: 0.04093404859, blue: 0.04867307097, alpha: 1), size: CGSize(width: 30, height: 30)))
        
        let feedback = GeneralModel(name: "Feedback", image: UIImage.fontAwesomeIcon(name: .commentAlt, style: .regular, textColor: UIColor.init(displayP3Red: 69/255, green: 162/255, blue: 217/255, alpha: 1), size: CGSize(width: 30, height: 30)))
        
        let rate = GeneralModel(name: "Rate This App", image: UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: #colorLiteral(red: 1, green: 0.5837637782, blue: 0.008648229763, alpha: 1), size: CGSize(width: 30, height: 30)))
        
        self.infoModels = [info1, info2]
        self.helpModels = [help1, help2]
        self.feedbackModel = [feedback]
        self.rateModel = [rate]
    }
}

