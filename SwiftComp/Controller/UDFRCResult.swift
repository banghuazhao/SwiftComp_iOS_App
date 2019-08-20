//
//  UDFRCResult.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class UDFRCResult: UIViewController {
    
    
    var materialPropertyName = MaterialPropertyName()
    var materialPropertyLabel = MaterialPropertyLabel()
    
    var typeOfAnalysis: typeOfAnalysis = .elastic
    var resultMaterialType: materialType = .transverselyIsotropic
    
    var engineeringConstantsTransverselyIsotropic = [Double](repeating: 0.0, count: 5)
    var engineeringConstantsTransverselyIsotropicThermal = [Double](repeating: 0.0, count: 2)
    
    var engineeringConstantsOrthotropic = [Double](repeating: 0.0, count: 9)
    var engineeringConstantsOrthotropicThermal = [Double](repeating: 0.0, count: 3)
    
    var planeStressReducedCompliance = [Double](repeating: 0.0, count: 9)
    var planeStressReducedStiffness = [Double](repeating: 0.0, count: 9)
    
    // layout
    
    var scrollView: UIScrollView = UIScrollView()
    
    // First section
    
    var engineeringConstantsCard: UIView = UIView()
    
    var engineeringConstantsTitleLabel: UILabel = UILabel()
    
    var engineeringConstantsLabel: [UILabel] = []
    
    var engineeringConstantsResultLabel: [UILabel] = []
    
    
    // Second section
    
    var planeStressReducedComplianceCard: UIView = UIView()
    
    var planeStressReducedComplianceTitleLabel: UILabel = UILabel()
    
    var planeStressReducedComplianceResultLabel: [UILabel] = []
    
    
    // Third section
    
    var planeStressReducedStiffnessCard: UIView = UIView()
    
    var planeStressReducedStiffnessTitleLabel: UILabel = UILabel()
    
    var planeStressReducedStiffnessResultLabel: [UILabel] = []
    
    
    
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
        scrollView.addSubview(engineeringConstantsCard)
        scrollView.addSubview(planeStressReducedComplianceCard)
        scrollView.addSubview(planeStressReducedStiffnessCard)
        
        
        // first section
        
        engineeringConstantsTitleLabel.text = "Engineering Constants"
        
        creatResultListCard(resultCard: engineeringConstantsCard, title: engineeringConstantsTitleLabel, label: &engineeringConstantsLabel, result: &engineeringConstantsResultLabel, aboveConstraint: scrollView.topAnchor, under: scrollView, typeOfAnalysis: typeOfAnalysis, materialType: resultMaterialType)
        
        
        // second section

        planeStressReducedComplianceTitleLabel.text = " Plane-stress Reduced Compliance "
        createResult3by3MatrixCard(resultCard: planeStressReducedComplianceCard, title: planeStressReducedComplianceTitleLabel, result: &planeStressReducedComplianceResultLabel, aboveConstraint: engineeringConstantsCard.bottomAnchor, under: scrollView)
        
  
        // third section
    
        planeStressReducedStiffnessTitleLabel.text = " Plane-stress Reduced Stiffness "
        createResult3by3MatrixCard(resultCard: planeStressReducedStiffnessCard, title: planeStressReducedStiffnessTitleLabel, result: &planeStressReducedStiffnessResultLabel, aboveConstraint: planeStressReducedComplianceCard.bottomAnchor, under: scrollView)
        planeStressReducedStiffnessCard.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    
    
    
    
    // MARK: Apply results
    
    func applyResult() {
        
        if resultMaterialType != .orthotropic {
            for i in 0...engineeringConstantsTransverselyIsotropic.count - 1 {
                
                if abs(engineeringConstantsTransverselyIsotropic[i]) > 100000 {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstantsTransverselyIsotropic[i])
                }
                else if abs(engineeringConstantsTransverselyIsotropic[i]) > 0.0001 {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3f", engineeringConstantsTransverselyIsotropic[i])
                }
                else if abs(engineeringConstantsTransverselyIsotropic[i]) < 0.000000000000001 {
                    engineeringConstantsResultLabel[i].text = "0"
                }
                else {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstantsTransverselyIsotropic[i])
                }
                engineeringConstantsResultLabel[i].adjustsFontSizeToFitWidth = true
            }

            if typeOfAnalysis == .thermalElatic {
                for i in 0...engineeringConstantsTransverselyIsotropicThermal.count - 1 {
                    
                    if abs(engineeringConstantsTransverselyIsotropicThermal[i]) > 100000 {
                        engineeringConstantsResultLabel[i+engineeringConstantsTransverselyIsotropic.count].text = String(format: "%.3e", engineeringConstantsTransverselyIsotropicThermal[i])
                    }
                    else if abs(engineeringConstantsTransverselyIsotropicThermal[i]) > 0.0001 {
                        engineeringConstantsResultLabel[i+engineeringConstantsTransverselyIsotropic.count].text = String(format: "%.3f", engineeringConstantsTransverselyIsotropicThermal[i])
                    }
                    else if abs(engineeringConstantsTransverselyIsotropicThermal[i]) < 0.000000000000001 {
                        engineeringConstantsResultLabel[i+engineeringConstantsTransverselyIsotropic.count].text = "0"
                    }
                    else {
                        engineeringConstantsResultLabel[i+engineeringConstantsTransverselyIsotropic.count].text = String(format: "%.3e", engineeringConstantsTransverselyIsotropicThermal[i])
                    }
                    engineeringConstantsResultLabel[i+engineeringConstantsTransverselyIsotropic.count].adjustsFontSizeToFitWidth = true
                }
            }
        } else {
            for i in 0...engineeringConstantsOrthotropic.count - 1 {
                
                if abs(engineeringConstantsOrthotropic[i]) > 100000 {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstantsOrthotropic[i])
                }
                else if abs(engineeringConstantsOrthotropic[i]) > 0.0001 {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3f", engineeringConstantsOrthotropic[i])
                }
                else if abs(engineeringConstantsOrthotropic[i]) < 0.000000000000001 {
                    engineeringConstantsResultLabel[i].text = "0"
                }
                else {
                    engineeringConstantsResultLabel[i].text = String(format: "%.3e", engineeringConstantsOrthotropic[i])
                }
                engineeringConstantsResultLabel[i].adjustsFontSizeToFitWidth = true
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...engineeringConstantsOrthotropicThermal.count - 1 {
                    
                    if abs(engineeringConstantsOrthotropicThermal[i]) > 100000 {
                        engineeringConstantsResultLabel[i+engineeringConstantsOrthotropic.count].text = String(format: "%.3e", engineeringConstantsOrthotropicThermal[i])
                    }
                    else if abs(engineeringConstantsOrthotropicThermal[i]) > 0.0001 {
                        engineeringConstantsResultLabel[i+engineeringConstantsOrthotropic.count].text = String(format: "%.3f", engineeringConstantsOrthotropicThermal[i])
                    }
                    else if abs(engineeringConstantsOrthotropicThermal[i]) < 0.000000000000001 {
                        engineeringConstantsResultLabel[i+engineeringConstantsOrthotropic.count].text = "0"
                    }
                    else {
                        engineeringConstantsResultLabel[i+engineeringConstantsOrthotropic.count].text = String(format: "%.3e", engineeringConstantsOrthotropicThermal[i])
                    }
                    engineeringConstantsResultLabel[i+engineeringConstantsOrthotropic.count].adjustsFontSizeToFitWidth = true
                }
            }
        }
        
        for i in 0...8 {
            
            if abs(planeStressReducedCompliance[i]) > 100000 {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3e", planeStressReducedCompliance[i])
            }
            else if abs(planeStressReducedCompliance[i]) > 0.0001 {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3f", planeStressReducedCompliance[i])
            }
            else if abs(planeStressReducedCompliance[i]) < 0.000000000000001 {
                planeStressReducedComplianceResultLabel[i].text = "0"
            }
            else {
                planeStressReducedComplianceResultLabel[i].text = String(format: "%.3e", planeStressReducedCompliance[i])
            }
            planeStressReducedComplianceResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
        for i in 0...8 {
            
            if abs(planeStressReducedStiffness[i]) > 100000 {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3e", planeStressReducedStiffness[i])
            }
            else if abs(planeStressReducedStiffness[i]) > 0.0001 {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3f", planeStressReducedStiffness[i])
            }
            else if abs(planeStressReducedStiffness[i]) < 0.000000000000001 {
                planeStressReducedStiffnessResultLabel[i].text = "0"
            }
            else {
                planeStressReducedStiffnessResultLabel[i].text = String(format: "%.3e", planeStressReducedStiffness[i])
            }
            planeStressReducedStiffnessResultLabel[i].adjustsFontSizeToFitWidth = true
        }
        
    }
    
    
    
    // MARK: Edit navigation bar
    
    func editNavigationBar() {
        
        navigationItem.title = "Result"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareResult))
    }
    
    @objc func shareResult() {
        
        var str : String = ""
        
        str = "Engineering Constants:\n"
        if resultMaterialType != .orthotropic {
            for i in 0...engineeringConstantsTransverselyIsotropic.count - 1 {
                str +=  materialPropertyLabel.transverselyIsotropic[i] + ": \t" + engineeringConstantsResultLabel[i].text! + "\n"
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...engineeringConstantsTransverselyIsotropicThermal.count - 1 {
                    str +=  materialPropertyLabel.transverselyIsotropicThermal[i] + ": \t" + engineeringConstantsResultLabel[i + engineeringConstantsTransverselyIsotropic.count].text! + "\n"
                }
            }
        } else {
            for i in 0...engineeringConstantsOrthotropic.count - 1 {
                str +=  materialPropertyLabel.orthotropic[i] + ": \t" + engineeringConstantsResultLabel[i].text! + "\n"
            }
            
            if typeOfAnalysis == .thermalElatic {
                for i in 0...engineeringConstantsOrthotropicThermal.count - 1 {
                    str +=  materialPropertyLabel.orthotropicThermal[i] + ": \t" + engineeringConstantsResultLabel[i + engineeringConstantsOrthotropic.count].text! + "\n"
                }
            }
        }
        str += "\n"
        
        str += "Plane-stress Reduced Compliance:\n"
        for i in 0...2 {
            for j in 0...2 {
                str += planeStressReducedComplianceResultLabel[i*3+j].text! + "\t"
            }
            str += "\n"
        }
        
        str += "\n"
        
        str += "Plane-stress Reduced Stiffness:\n"
        for i in 0...2 {
            for j in 0...2 {
                str += planeStressReducedStiffnessResultLabel[i*3+j].text! + "\t"
            }
            str += "\n"
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
