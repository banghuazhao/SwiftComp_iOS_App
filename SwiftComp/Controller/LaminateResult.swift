//
//  LaminateResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/28/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class LaminateResult: UIViewController {
    
    var typeOfAnalysis : typeOfAnalysis = .elastic
    var resultMaterialType : materialType = .monoclinic
    var resultInPlaneMaterialType: materialType = .inPlateMonoclinic
    
    var effective3DPropertiesMonoclinic = [Double](repeating: 0.0, count: 13)
    var effective3DPropertiesMonoclinicThermal = [Double](repeating: 0.0, count: 4)
    
    var effective3DPropertiesAnisotropic = [Double](repeating: 0.0, count: 21)
    var effective3DPropertiesAnisotropicThermal = [Double](repeating: 0.0, count: 6)
    
    var effectiveInPlaneProperties = [Double](repeating: 0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0, count: 6)
    
    var materialPropertyLabel = MaterialPropertyLabel()
    
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
        
        editNavigationBar()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Create layout
    
    func createLayout() {
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        scrollView.addSubview(threeDPropertiesCard)
        scrollView.addSubview(inPlanePropertiesCard)
        scrollView.addSubview(flexuralPropertiesCard)
        
        
        // first section
        
        threeDPropertiesTitleLabel.text = "3D Properties"
        
        creatResultListCard(resultCard: threeDPropertiesCard, title: threeDPropertiesTitleLabel, label: &threeDPropertiesLabel, result: &threeDPropertiesResultLabel, aboveConstraint: scrollView.topAnchor, under: scrollView, typeOfAnalysis: typeOfAnalysis, materialType: resultMaterialType)
        
        // second section

        inPlanePropertiesTitleLabel.text = "In-plane Properties"

        creatResultListCard(resultCard: inPlanePropertiesCard, title: inPlanePropertiesTitleLabel, label: &inPlanePropertiesLabel, result: &inPlanePropertiesResultLabel, aboveConstraint: threeDPropertiesCard.bottomAnchor, under: scrollView, typeOfAnalysis: typeOfAnalysis, materialType: resultInPlaneMaterialType)

        
        // third section
        
        flexuralPropertiesTitleLabel.text = "Flexural Properties"
        
        creatResultListCard(resultCard: flexuralPropertiesCard, title: flexuralPropertiesTitleLabel, label: &flexuralPropertiesLabel, result: &flexuralPropertiesResultLabel, aboveConstraint: inPlanePropertiesCard.bottomAnchor, under: scrollView, typeOfAnalysis: typeOfAnalysis, materialType: resultInPlaneMaterialType)
        
        flexuralPropertiesCard.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        if resultMaterialType != .anisotropic {
            for i in 0...effective3DPropertiesMonoclinic.count - 1 {
                
                if abs(effective3DPropertiesMonoclinic[i]) > 100000 {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DPropertiesMonoclinic[i])
                }
                else if abs(effective3DPropertiesMonoclinic[i]) > 0.0001 {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3f", effective3DPropertiesMonoclinic[i])
                }
                else if abs(effective3DPropertiesMonoclinic[i]) < 0.000000000000001 {
                    threeDPropertiesResultLabel[i].text = "0"
                }
                else {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DPropertiesMonoclinic[i])
                }
                threeDPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...effective3DPropertiesMonoclinicThermal.count - 1 {
                    
                    if abs(effective3DPropertiesMonoclinicThermal[i]) > 100000 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesMonoclinic.count].text = String(format: "%.3e", effective3DPropertiesMonoclinicThermal[i])
                    }
                    else if abs(effective3DPropertiesMonoclinicThermal[i]) > 0.0001 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesMonoclinic.count].text = String(format: "%.3f", effective3DPropertiesMonoclinicThermal[i])
                    }
                    else if abs(effective3DPropertiesMonoclinicThermal[i]) < 0.000000000000001 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesMonoclinic.count].text = "0"
                    }
                    else {
                        threeDPropertiesResultLabel[i+effective3DPropertiesMonoclinic.count].text = String(format: "%.3e", effective3DPropertiesMonoclinicThermal[i])
                    }
                    threeDPropertiesResultLabel[i+effective3DPropertiesMonoclinic.count].adjustsFontSizeToFitWidth = true
                }
            }
        } else {
            for i in 0...effective3DPropertiesAnisotropic.count - 1 {
                
                if abs(effective3DPropertiesAnisotropic[i]) > 100000 {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DPropertiesAnisotropic[i])
                }
                else if abs(effective3DPropertiesAnisotropic[i]) > 0.0001 {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3f", effective3DPropertiesAnisotropic[i])
                }
                else if abs(effective3DPropertiesAnisotropic[i]) < 0.000000000000001 {
                    threeDPropertiesResultLabel[i].text = "0"
                }
                else {
                    threeDPropertiesResultLabel[i].text = String(format: "%.3e", effective3DPropertiesAnisotropic[i])
                }
                threeDPropertiesResultLabel[i].adjustsFontSizeToFitWidth = true
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...effective3DPropertiesAnisotropicThermal.count - 1 {
                    
                    if abs(effective3DPropertiesAnisotropicThermal[i]) > 100000 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesAnisotropic.count].text = String(format: "%.3e", effective3DPropertiesAnisotropicThermal[i])
                    }
                    else if abs(effective3DPropertiesAnisotropicThermal[i]) > 0.0001 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesAnisotropic.count].text = String(format: "%.3f", effective3DPropertiesAnisotropicThermal[i])
                    }
                    else if abs(effective3DPropertiesAnisotropicThermal[i]) < 0.000000000000001 {
                        threeDPropertiesResultLabel[i+effective3DPropertiesAnisotropic.count].text = "0"
                    }
                    else {
                        threeDPropertiesResultLabel[i+effective3DPropertiesAnisotropic.count].text = String(format: "%.3e", effective3DPropertiesAnisotropicThermal[i])
                    }
                    threeDPropertiesResultLabel[i+effective3DPropertiesAnisotropic.count].adjustsFontSizeToFitWidth = true
                }
            }
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
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "Result"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareResult))
    }
    
    @objc func shareResult() {
        
        var str : String = ""
        
        str = "3D Properties:\n"
        if resultMaterialType != .anisotropic {
            for i in 0...effective3DPropertiesMonoclinic.count - 1 {
                str +=  materialPropertyLabel.monoclinic[i] + ": \t" + threeDPropertiesResultLabel[i].text! + "\n"
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...effective3DPropertiesMonoclinicThermal.count - 1 {
                    str +=  materialPropertyLabel.monoclinicThermal[i] + ": \t" + threeDPropertiesResultLabel[i + effective3DPropertiesMonoclinic.count].text! + "\n"
                }
            }
        } else {
            for i in 0...effective3DPropertiesAnisotropic.count - 1 {
                str +=  materialPropertyLabel.anisotropic[i] + ": \t" + threeDPropertiesResultLabel[i].text! + "\n"
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...effective3DPropertiesAnisotropicThermal.count - 1 {
                    str +=  materialPropertyLabel.anisotropicThermal[i] + ": \t" + threeDPropertiesResultLabel[i + effective3DPropertiesAnisotropic.count].text! + "\n"
                }
            }
        }
        
        str += "\n"
        
        str += "In-plane Properties:\n"
        for i in 0...5 {
            str += materialPropertyLabel.inPlateMonoclinic[i] + ": \t" + inPlanePropertiesResultLabel[i].text! + "\n"
        }
        
        str += "\n"
        
        str += "Flexural Properties:\n"
        for i in 0...5 {
            str += materialPropertyLabel.inPlateMonoclinic[i] + ": \t" + flexuralPropertiesResultLabel[i].text! + "\n"
        }
        
        let file = getDocumentsDirectory().appendingPathComponent("Result.txt")
        
        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    
        
        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }



}
