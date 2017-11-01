//
//  LaminateResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/28/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class LaminateResult: UIViewController {
    
    var effective3DProperties = [Double](repeating: 0, count: 17)
    var effectiveInPlaneProperties = [Double](repeating: 0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0, count: 6)
    
    var  materialPropertyName = MaterialPropertyName()
    
    var scrollView: UIScrollView = UIScrollView()
    
    // First section

    var threeDPropertiesCard: UIView = UIView()
    
    var threeDPropertiesTitleLabel: UILabel = UILabel()
    
    var threeDPropertiesLabel: [UILabel] = []
    
    var threeDPropertiesResultLabel: [UILabel] = []
    
    
    // Second section
    
    var inPlanePropertiesCard: UIView = UIView()
    
    var inPlanePropertiesTitleLabel: UILabel = UILabel()
    
    var inPlanePropertiesLabel: [UILabel] = []
    
    var inPlanePropertiesResultLabel: [UILabel] = []
    
    // Third section
    
    var flexuralPropertiesCard: UIView = UIView()
    
    var flexuralPropertiesTitleLabel: UILabel = UILabel()
    
    var flexuralPropertiesLabel: [UILabel] = []
    
    var flexuralPropertiesResultLabel: [UILabel] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        createLayout()
        
        applyResult()
        
        navigationItem.title = "Result"
        
    }
    
    
    // MARK: Create layout
    
    func createLayout() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1200)
        scrollView.addSubview(threeDPropertiesCard)
        scrollView.addSubview(inPlanePropertiesCard)
        scrollView.addSubview(flexuralPropertiesCard)
        
        
        // first section
        
        threeDPropertiesTitleLabel.text = "3D Properties"
        for i in 0...16 {
            threeDPropertiesLabel.append(UILabel())
            threeDPropertiesLabel[i].text = materialPropertyName.monoclinic[i]
            
            threeDPropertiesResultLabel.append(UILabel())
        }
        
        creatResultListCard(resultCard: threeDPropertiesCard, title: threeDPropertiesTitleLabel, label: threeDPropertiesLabel, result: threeDPropertiesResultLabel, aboveConstraint: scrollView.topAnchor, under: scrollView)
        
        // second section

        inPlanePropertiesTitleLabel.text = "In-plane Properties"
        for i in 0...5 {
            inPlanePropertiesLabel.append(UILabel())
            inPlanePropertiesLabel[i].text = materialPropertyName.plate[i]

            inPlanePropertiesResultLabel.append(UILabel())
        }

        creatResultListCard(resultCard: inPlanePropertiesCard, title: inPlanePropertiesTitleLabel, label: inPlanePropertiesLabel, result: inPlanePropertiesResultLabel, aboveConstraint: threeDPropertiesCard.bottomAnchor, under: scrollView)

        
        // third section
        
        flexuralPropertiesTitleLabel.text = "Flexural Properties"
        for i in 0...5 {
            flexuralPropertiesLabel.append(UILabel())
            flexuralPropertiesLabel[i].text = materialPropertyName.plate[i]
            
            flexuralPropertiesResultLabel.append(UILabel())
        }
        
        creatResultListCard(resultCard: flexuralPropertiesCard, title: flexuralPropertiesTitleLabel, label: flexuralPropertiesLabel, result: flexuralPropertiesResultLabel, aboveConstraint: inPlanePropertiesCard.bottomAnchor, under: scrollView)

        
    }
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        for i in 0...16 {
            
            if abs(effective3DProperties[i]) > 100000 {
                threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) > 0.0001 {
                threeDPropertiesResultLabel[i].text = String(format: "%.3f", effective3DProperties[i])
            }
            else if abs(effective3DProperties[i]) < 0.000000000000001 {
                threeDPropertiesResultLabel[i].text = "0"
            }
            else {
                threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DProperties[i])
            }
            threeDPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...5 {
            
            if abs(effectiveInPlaneProperties[i]) > 100000 {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) > 0.0001 {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3f", effectiveInPlaneProperties[i])
            }
            else if abs(effectiveInPlaneProperties[i]) < 0.000000000000001 {
                inPlanePropertiesResultLabel[i].text = "0"
            }
            else {
                inPlanePropertiesResultLabel[i].text = String(format: "%.3e", effectiveInPlaneProperties[i])
            }
            
            if abs(effectiveFlexuralProperties[i]) > 100000 {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) > 0.0001 {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3f", effectiveFlexuralProperties[i])
            }
            else if abs(effectiveFlexuralProperties[i]) < 0.000000000000001 {
                flexuralPropertiesResultLabel[i].text = "0"
            }
            else {
                flexuralPropertiesResultLabel[i].text = String(format: "%.3e", effectiveFlexuralProperties[i])
            }
            
            inPlanePropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
            flexuralPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        
        
    }




}
