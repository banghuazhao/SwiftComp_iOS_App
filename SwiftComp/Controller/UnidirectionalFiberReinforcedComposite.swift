//
//  UnidirectionalFiberReinforcedComposite.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/5/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class UnidirectionalFiberReinforcedComposite: UITableViewController {
    
    var e1 = 0.0, e2 = 0.0, g12 = 0.0, v12 = 0.0, v23 = 0.0
    var alterControllerMethod : UIAlertController!
    var alterControllerFiber : UIAlertController!
    var alterControllerMatrix : UIAlertController!

    
    @IBOutlet weak var methodName: UIButton!
    @IBOutlet weak var fiberName: UIButton!
    @IBOutlet weak var matrixName: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    
    
    @IBOutlet var fiberEngineeringConstants: [UITextField]!
    @IBOutlet var matrixEngineeringConstants: [UITextField]!
    
    
    @IBOutlet weak var volumeFractionLabel: UILabel!
    @IBAction func volumeFractionSlider(_ sender: UISlider) {
        volumeFractionLabel.text = "Fiber Volume Fraction: " + String(format: "%.2f", sender.value)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        calculateButton.dataBaseButtonDesign()
        methodName.dataBaseButtonDesign()
        fiberName.dataBaseButtonDesign()
        matrixName.dataBaseButtonDesign()
        
        createActionSheet()
        
        changeMaterialDataField()
        
        editKeyboard()

    }
    
    
    @IBAction func method(_ sender: UIButton) {
        sender.flash()
        self.present(alterControllerMethod, animated: true, completion: nil)
    }
    
    @IBAction func fiberMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(alterControllerFiber, animated: true, completion: nil)
    }
    
    @IBAction func matrixMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(alterControllerMatrix, animated: true, completion: nil)
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        sender.flash()
        calculateEffectiveEngineeringConstants()
        performSegue(withIdentifier: "unidirectionalCalculate", sender: self)
    }
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        // Action sheet for method
        alterControllerMethod = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let voigtAction = UIAlertAction(title: "Voigt Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodName.setTitle("Voigt Rules of Mixture", for: UIControlState.normal)
        }
        
        let reussAction = UIAlertAction(title: "Reuss Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodName.setTitle("Reuss Rules of Mixture", for: UIControlState.normal)
        }
        
        let hybridAction = UIAlertAction(title: "Hybrid Rules of Mixture", style: UIAlertActionStyle.default) { (action) -> Void in
            self.methodName.setTitle("Hybird Rules of Mixture", for: UIControlState.normal)
        }
        
        alterControllerMethod.addAction(voigtAction)
        alterControllerMethod.addAction(reussAction)
        alterControllerMethod.addAction(hybridAction)
        alterControllerMethod.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // Action sheet for fiber material
        alterControllerFiber = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let fiberAction1 = UIAlertAction(title: "E-Glass", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("E-Glass", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction2 = UIAlertAction(title: "S-Glass", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("S-Glass", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction3 = UIAlertAction(title: "Carbon (IM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("Carbon (IM)", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction4 = UIAlertAction(title: "Carbon (HM)", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("Carbon (HM)", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction5 = UIAlertAction(title: "Boron", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("Boron", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction6 = UIAlertAction(title: "Kelvar-49", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("Kelvar-49", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let fiberAction7 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.fiberName.setTitle("  Custom Material Properties  ", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        
        alterControllerFiber.addAction(fiberAction1)
        alterControllerFiber.addAction(fiberAction2)
        alterControllerFiber.addAction(fiberAction3)
        alterControllerFiber.addAction(fiberAction4)
        alterControllerFiber.addAction(fiberAction5)
        alterControllerFiber.addAction(fiberAction6)
        alterControllerFiber.addAction(fiberAction7)
        alterControllerFiber.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

        // Action sheet for matrix material
        alterControllerMatrix = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let matrixAction1 = UIAlertAction(title: "Epoxy", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("Epoxy", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction2 = UIAlertAction(title: "Polyester", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("Polyester", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction3 = UIAlertAction(title: "Polyimide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("Polyimide", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction4 = UIAlertAction(title: "PEEK", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("PEEK", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction5 = UIAlertAction(title: "Copper", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("Copper", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction6 = UIAlertAction(title: "Silicon Carbide", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("Silicon Carbide", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let matrixAction7 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.matrixName.setTitle("  Custom Material Properties  ", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        
        alterControllerMatrix.addAction(matrixAction1)
        alterControllerMatrix.addAction(matrixAction2)
        alterControllerMatrix.addAction(matrixAction3)
        alterControllerMatrix.addAction(matrixAction4)
        alterControllerMatrix.addAction(matrixAction5)
        alterControllerMatrix.addAction(matrixAction6)
        alterControllerMatrix.addAction(matrixAction7)
        alterControllerMatrix.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
    }
    
    
    // MARK: Edit keyboard
    
    func editKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        for i in 0...(fiberEngineeringConstants.count-1) {
            fiberEngineeringConstants[i].inputAccessoryView = toolBar
        }
        
        for i in 0...(matrixEngineeringConstants.count-1) {
            matrixEngineeringConstants[i].inputAccessoryView = toolBar
        }
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    

    // MARK: Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
    
    // MARK: Change material data fields
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        let fiberCurrentName = fiberName.currentTitle
        let matrixCurrentName = matrixName.currentTitle

        
        for material in allMaterials.list {
            if fiberCurrentName == material.materialName {
                fiberEngineeringConstants[0].text = String(format: "%.2f", material.materialProperties["E1"]!)
                fiberEngineeringConstants[1].text = String(format: "%.2f", material.materialProperties["E2"]!)
                fiberEngineeringConstants[2].text = String(format: "%.2f", material.materialProperties["G12"]!)
                fiberEngineeringConstants[3].text = String(format: "%.2f", material.materialProperties["v12"]!)
                fiberEngineeringConstants[4].text = String(format: "%.2f", material.materialProperties["v23"]!)
            }
            else if fiberCurrentName == "  Custom Material Properties  " {
                fiberEngineeringConstants[0].text = ""
                fiberEngineeringConstants[1].text = ""
                fiberEngineeringConstants[2].text = ""
                fiberEngineeringConstants[3].text = ""
                fiberEngineeringConstants[4].text = ""
            }
        }
        
        for material in allMaterials.list {
            if matrixCurrentName == material.materialName {
                matrixEngineeringConstants[0].text = String(format: "%.2f", material.materialProperties["E1"]!)
                matrixEngineeringConstants[1].text = String(format: "%.2f", material.materialProperties["v12"]!)
            }
            else if matrixCurrentName == "  Custom Material Properties  " {
                matrixEngineeringConstants[0].text = ""
                matrixEngineeringConstants[1].text = ""
            }
        }
        
    }
    
    
    // MARK: Inverse operation for matrix
    
    func invert(matrix : [Double]) -> [Double] {
        var inMatrix = matrix
        let N = __CLPK_integer(sqrt(Double(matrix.count)))
        var pivots = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace = [Double](repeating: 0.0, count: Int(N))
        var error : __CLPK_integer = 0
        
        // Mutable copies to circumvent "Simultaneous accesses to var 'N'" error in Swift 4
        var N1 = N, N2 = N, N3 = N
        dgetrf_(&N1, &N2, &inMatrix, &N3, &pivots, &error)
        dgetri_(&N1, &inMatrix, &N2, &pivots, &workspace, &N3, &error)
        return inMatrix
    }
    
    
    // MARK: Calculate effective engineering constants
    
    func calculateEffectiveEngineeringConstants() {
        
        if let ef1 = Double(fiberEngineeringConstants[0].text!), let ef2 = Double(fiberEngineeringConstants[1].text!), let gf12 = Double(fiberEngineeringConstants[2].text!), let vf12 = Double(fiberEngineeringConstants[3].text!), let vf23 = Double(fiberEngineeringConstants[4].text!), let em = Double(matrixEngineeringConstants[0].text!), let vm = Double(matrixEngineeringConstants[1].text!) {
            
            let s = volumeFractionLabel.text!
            
            var Vf = Double(s[s.index(s.endIndex, offsetBy: -4) ..< s.endIndex])!
            var Vm = 1.0 - Vf
            
            let Sf : [Double] = [1/ef1, -vf12/ef1, -vf12/ef1, 0, 0, 0, -vf12/ef1, 1/ef2, -vf23/ef2, 0, 0, 0, -vf12/ef1, -vf23/ef2, 1/ef1, 0, 0, 0, 0, 0, 0, 2*(1+vf23)/ef2, 0, 0, 0, 0, 0, 0, 1/gf12, 0, 0, 0, 0, 0, 0, 1/gf12]
            let Sm : [Double] = [1/em, -vm/em, -vm/em, 0, 0, 0, -vm/em, 1/em, -vm/em, 0, 0, 0, -vm/em, -vm/em, 1/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em, 0, 0, 0, 0, 0, 0, 2*(1+vm)/em]
            var SRs = [Double](repeating: 0, count: 36)
            var SVs = [Double](repeating: 0, count: 36)
            
            var Cf = [Double](repeating: 0, count: 36)
            var Cm = [Double](repeating: 0, count: 36)
            var CVs = [Double](repeating: 0, count: 36)

            
            var temp1 = [Double](repeating: 0, count: 36)
            var temp2 = [Double](repeating: 0, count: 36)
            
            vDSP_vsmulD(Sf, 1, &Vf, &temp1, 1, 36)
            vDSP_vsmulD(Sm, 1, &Vm, &temp2, 1, 36)
            vDSP_vaddD(temp1, 1, temp2, 1, &SRs, 1, 36)
            
            Cf = invert(matrix : Sf)
            Cm = invert(matrix : Sm)
            
            vDSP_vsmulD(Cf, 1, &Vf, &temp1, 1, 36)
            vDSP_vsmulD(Cm, 1, &Vm, &temp2, 1, 36)
            vDSP_vaddD(temp1, 1, temp2, 1, &CVs, 1, 36)
            
            SVs = invert(matrix: CVs)
            
            // Voigt results
            let eV1 = 1/SVs[0]
            let eV2 = 1/SVs[7]
            let gV12 = 1/SVs[35]
            let vV12 = -eV1*SVs[1]
            let vV23 = -eV2*SVs[8]
            
            // Reuss results
            let eR1 = 1/SRs[0]
            let eR2 = 1/SRs[7]
            let gR12 = 1/SRs[35]
            let vR12 = -eR1*SRs[1]
            let vR23 = -eR2*SRs[8]
            
            //Hybird results
            let gf12 = ef1/(2*(1+vf12))
            let gm = em/(2*(1+vm))
            let eH1 = Vf*ef1 + Vm*em
            let vH12 = Vf*vf12 + Vm*vm
            let eH2 = 1 / (Vf/ef2 + Vm/em - (Vf*Vm*pow(em*vf12-ef1*vm, 2)) / (ef1*em*(ef1*Vf+em*Vm)) )
            let vH23 = eH2 * (Vf*(vf23/ef2+vf12*vf12/ef1) + Vm*vm*(1+vm)/em - vH12*vH12/eH1)
            let gH12 = 1 / (Vf/gf12 + Vm/gm)
            
            if methodName.currentTitle! == "Voigt Rules of Mixture" {
                e1 = eV1
                e2 = eV2
                g12 = gV12
                v12 = vV12
                v23 = vV23
            }
            else if methodName.currentTitle! == "Reuss Rules of Mixture" {
                e1 = eR1
                e2 = eR2
                g12 = gR12
                v12 = vR12
                v23 = vR23
            }
            else if methodName.currentTitle! == "Hybrid Rules of Mixture" {
                e1 = eH1
                e2 = eH2
                g12 = gH12
                v12 = vH12
                v23 = vH23
            }
        }
        else
        {
            let alter = UIAlertController(title: "Wrong value for material properties", message: "Please double check", preferredStyle: UIAlertControllerStyle.alert)
            alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alter, animated: true, completion: nil)
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unidirectionalCalculate" {
            let destination = segue.destination as! UIFiberResults
            var Se = [1/e1, -v12/e1, 0, -v12/e1, 1/e2, 0, 0, 0, 1/g12]
            var Q = invert(matrix: Se)
            
            destination.e1 = e1
            destination.e2 = e2
            destination.g12 = g12
            destination.v12 = v12
            destination.v23 = v23
            
            destination.Se[0] = Se[0]
            destination.Se[1] = Se[1]
            destination.Se[2] = Se[2]
            destination.Se[3] = Se[3]
            destination.Se[4] = Se[4]
            destination.Se[5] = Se[5]
            destination.Se[6] = Se[6]
            destination.Se[7] = Se[7]
            destination.Se[8] = Se[8]
            
            destination.Q[0] = Q[0]
            destination.Q[1] = Q[1]
            destination.Q[2] = Q[2]
            destination.Q[3] = Q[3]
            destination.Q[4] = Q[4]
            destination.Q[5] = Q[5]
            destination.Q[6] = Q[6]
            destination.Q[7] = Q[7]
            destination.Q[8] = Q[8]
        }
    }

}


