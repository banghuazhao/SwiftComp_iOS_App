//
//  Laminate.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/14/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import Accelerate

class Laminate: UITableViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    var effective3DProperties = [Double](repeating: 0.0, count: 9)
    var effectiveInplaneProperties = [Double](repeating: 0.0, count: 6)
    var effectiveFlexuralProperties = [Double](repeating: 0.0, count: 6)
    
    var alterControllerLayUp : UIAlertController!
    var alterControllerMaterial : UIAlertController!


    @IBOutlet weak var layupDataField: UITextField!
    @IBOutlet weak var layUpSequence: UIButton!
    @IBOutlet weak var materialName: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet var engineeringConstants: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.layupDataField.delegate = self

        layUpSequence.applyDesign()
        materialName.applyDesign()
        calculateButton.applyDesign()
        
        createActionSheet()
        
        changeMaterialDataField()
        
        editKeyboard()

    }

    
    @IBAction func changeLayup(_ sender: UIButton) {
        sender.flash()
        self.present(alterControllerLayUp, animated: true, completion: nil)
        
    }
    
    @IBAction func changeMaterial(_ sender: UIButton) {
        sender.flash()
        self.present(alterControllerMaterial, animated: true, completion: nil)
    }
    
    @IBAction func calculateAction(_ sender: UIButton) {
        
        sender.flash()
        
        if calculateResult() {
            performSegue(withIdentifier: "laminateResultSegue", sender: self)
        }
        
    }
    
    
    // MARK: Text field delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    // MARK: Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopover" {
            let dest = segue.destination
            dest.popoverPresentationController?.delegate = self
        }
        else if segue.identifier == "laminateResultSegue" {
            let destination = segue.destination as! LaminateResults
            
            for i in 0...8 {
                destination.effective3DProperties[i] = effective3DProperties[i]
            }
            
            for i in 0...5 {
                destination.effectiveInPlaneProperties[i] = effectiveInplaneProperties[i]
                destination.effectiveFlexuralProperties[i] = effectiveFlexuralProperties[i]
            }
            
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
    // MARK: Create action sheet
    
    func createActionSheet() {
        
        // Action sheet for method
        alterControllerLayUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let layUp1 = UIAlertAction(title: "[0/90]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("[0/90]", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        let layUp2 = UIAlertAction(title: "[45/-45]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("[45/-45]", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        let layUp3 = UIAlertAction(title: "[0/30/-30]", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("[0/30/-30]", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        let layUp4 = UIAlertAction(title: "[0/60/-60]s", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("[0/60/-60]s", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        let layUp5 = UIAlertAction(title: "[0/90/45/-45]s", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("[0/90/45/-45]s", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        let layUp6 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.layUpSequence.setTitle("", for: UIControlState.normal)
            self.changeLayupDataField()
            self.layUpSequence.setTitle("Layup Database", for: UIControlState.normal)
        }
        
        alterControllerLayUp.addAction(layUp1)
        alterControllerLayUp.addAction(layUp2)
        alterControllerLayUp.addAction(layUp3)
        alterControllerLayUp.addAction(layUp4)
        alterControllerLayUp.addAction(layUp5)
        alterControllerLayUp.addAction(layUp6)
        alterControllerLayUp.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // Action sheet for fiber material
        alterControllerMaterial = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let material1 = UIAlertAction(title: "IM7/8552", style: UIAlertActionStyle.default) { (action) -> Void in
            self.materialName.setTitle("IM7/8552", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let material2 = UIAlertAction(title: "T2C190/F155", style: UIAlertActionStyle.default) { (action) -> Void in
            self.materialName.setTitle("T2C190/F155", for: UIControlState.normal)
            self.changeMaterialDataField()
        }
        let material3 = UIAlertAction(title: "Define Your Own", style: UIAlertActionStyle.default) { (action) -> Void in
            self.materialName.setTitle("  Custom Material Properties  ", for: UIControlState.normal)
            self.changeMaterialDataField()
        }

        alterControllerMaterial.addAction(material1)
        alterControllerMaterial.addAction(material2)
        alterControllerMaterial.addAction(material3)
        alterControllerMaterial.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
    }
    
    // MARK: Change material data fields
    func changeMaterialDataField() {
        let allMaterials = MaterialBank()
        
        if let materialCurrentName = materialName.currentTitle {
            for material in allMaterials.list {
                if materialCurrentName == material.materialName {
                    engineeringConstants[0].text = String(format: "%.2f", material.materialProperties["E1"]!)
                    engineeringConstants[1].text = String(format: "%.2f", material.materialProperties["E2"]!)
                    engineeringConstants[2].text = String(format: "%.2f", material.materialProperties["E3"]!)
                    engineeringConstants[3].text = String(format: "%.2f", material.materialProperties["G12"]!)
                    engineeringConstants[4].text = String(format: "%.2f", material.materialProperties["G13"]!)
                    engineeringConstants[5].text = String(format: "%.2f", material.materialProperties["G23"]!)
                    engineeringConstants[6].text = String(format: "%.2f", material.materialProperties["v12"]!)
                    engineeringConstants[7].text = String(format: "%.2f", material.materialProperties["v13"]!)
                    engineeringConstants[8].text = String(format: "%.2f", material.materialProperties["v23"]!)
                }
                else if materialCurrentName == "  Custom Material Properties  "{
                    engineeringConstants[0].text = ""
                    engineeringConstants[1].text = ""
                    engineeringConstants[2].text = ""
                    engineeringConstants[3].text = ""
                    engineeringConstants[4].text = ""
                    engineeringConstants[5].text = ""
                    engineeringConstants[6].text = ""
                    engineeringConstants[7].text = ""
                    engineeringConstants[8].text = ""
                }
            }
        }
        
    }
    
    // MARK: Change layup data field
    func changeLayupDataField() {
        if layUpSequence.currentTitle == "User Define" {
            layupDataField.text = ""
        }
        else {
            layupDataField.text = layUpSequence.currentTitle
        }
    }
    
    
    // MARK: Edit keyboard
    
    func editKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        for i in 0...(engineeringConstants.count-1) {
            engineeringConstants[i].inputAccessoryView = toolBar
        }
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    // MARK: Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
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
    
    
    // MARK: Calculate result
    
    func calculateResult() -> Bool {
        
        let alter = UIAlertController(title: "Wrong value", message: "Please double check", preferredStyle: UIAlertControllerStyle.alert)
        alter.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if let e1 = Double(engineeringConstants[0].text!), let e2 = Double(engineeringConstants[1].text!), let e3 = Double(engineeringConstants[2].text!), let g12 = Double(engineeringConstants[3].text!), let g13 = Double(engineeringConstants[4].text!), let g23 = Double(engineeringConstants[5].text!), let v12 = Double(engineeringConstants[6].text!), let v13 = Double(engineeringConstants[7].text!), let v23 = Double(engineeringConstants[8].text!), let layup = layupDataField.text {
            
            if layup != "" {

                let str = layup
                var rBefore : Int = 1
                var rAfter : Int = 1
                var symmetry : Int = 1
                var baseLayup : String
                var baseLayupSequence = [Double]()
                var layupSequence = [Double]()
                
                if str.split(separator: "]").count == 2 {
                    baseLayup = str.split(separator: "]")[0].replacingOccurrences(of: "[", with: "")
                    let rsr = str.split(separator: "]")[1]
                    if rsr.split(separator: "s").count == 2 {
                        symmetry = 2
                        if let i = Int(rsr.split(separator: "s")[0]), let j = Int(rsr.split(separator: "s")[1]) {
                            rBefore = i
                            rAfter = j
                        }
                        else {
                            self.present(alter, animated: true, completion: nil)
                            return false
                        }
                    }
                    else if rsr.contains("s") {
                        symmetry = 2
                        if (rsr[rsr.startIndex] == "s") && (rsr == "s") {
                            rAfter = 1
                            rBefore = 1
                        }
                        else if rsr[rsr.startIndex] == "s"{
                            rBefore = 1
                            if rsr.split(separator: "s") != [] {
                                if let i = Int(rsr.split(separator: "s")[0]) {
                                    rAfter = i
                                }
                                else {
                                    self.present(alter, animated: true, completion: nil)
                                    return false
                                }
                            }
                            else {
                                self.present(alter, animated: true, completion: nil)
                                return false
                            }
                        }
                        else {
                            rAfter = 1
                            if let i = Int(rsr.split(separator: "s")[0]) {
                                rBefore = i
                            }
                            else {
                                self.present(alter, animated: true, completion: nil)
                                return false
                            }
                        }
                    }
                    else {
                        symmetry = 1
                        rBefore = 1
                        if let i = Int(rsr) {
                            rAfter = i
                        }
                        else {
                            self.present(alter, animated: true, completion: nil)
                            return false
                        }
                    }
                    
                }
                else {
                    baseLayup = str.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
                    rBefore = 1
                    rAfter = 1
                    symmetry = 1
                }
                
                for i in baseLayup.components(separatedBy: "/") {
                    if let j = Double(i) {
                        baseLayupSequence.append(j)
                    }
                    else {
                        self.present(alter, animated: true, completion: nil)
                        return false
                    }
                }
                
                let nPly = baseLayupSequence.count * rBefore * symmetry * rAfter
                
                if nPly > 0 {
                    var t : Double = 1.0
                    
                    var bzi = [Double]()
                    
                    for i in 1...nPly {
                        bzi.append((-Double(nPly+1)*t)/2 + Double(i)*t)
                    }

                    
                    for _ in 1...rBefore {
                        for i in baseLayupSequence {
                            layupSequence.append(i)
                        }
                    }
                    
                    baseLayupSequence = layupSequence
                    
                    if symmetry == 2 {
                        for i in baseLayupSequence.reversed() {
                            layupSequence.append(i)
                        }
                    }
                    
                    baseLayupSequence = layupSequence
                    
                    if rAfter > 1 {
                        for _ in 2...rAfter {
                            for i in baseLayupSequence {
                                layupSequence.append(i)
                            }
                        }
                    }
                    
                    let Sp : [Double] = [1/e1, -v12/e1, -v13/e1, 0, 0, 0, -v12/e1, 1/e2, -v23/e2, 0, 0, 0, -v13/e1, -v23/e2, 1/e3, 0, 0, 0, 0, 0, 0, 1/g23, 0, 0, 0, 0, 0, 0, 1/g13, 0, 0, 0, 0, 0, 0, 1/g12]
                    let Cp = invert(matrix: Sp)
                    
                    var tempCts = [Double](repeating: 0.0, count: 9)
                    var tempCets = [Double](repeating: 0.0, count: 9)
                    var Qs = [Double](repeating: 0.0, count: 9)
                    var Cts = [Double](repeating: 0.0, count: 9)
                    var Cets = [Double](repeating: 0.0, count: 9)
                    var Ces = [Double](repeating: 0.0, count: 9)
                    // Calculate effective 3D properties
                    for i in 1...nPly {
                        
                        // Set up
                        let c = cos(layupSequence[i-1] * Double.pi / 180)
                        let s = sin(layupSequence[i-1] * Double.pi / 180)
                        let Rsigma = [c*c, s*s, 0, 0, 0, -2*s*c, s*s, c*c, 0, 0, 0, 2*s*c, 0, 0, 1, 0, 0, 0, 0, 0, 0, c, s, 0, 0 ,0 ,0, -s, c, 0, s*c, -s*c, 0, 0, 0, c*c-s*s]
                        var RsigmaT = [Double](repeating: 0.0, count: 36)
                        vDSP_mtransD(Rsigma, 1, &RsigmaT, 1, 6, 6)
            
                        var C = [Double](repeating: 0.0, count: 36)
                        var temp1 = [Double](repeating: 0.0, count: 36)
                        vDSP_mmulD(Rsigma,1,Cp,1,&temp1,1,6,6,6)
                        vDSP_mmulD(temp1,1,RsigmaT,1,&C,1,6,6,6)
                        
                        // Get Ce, Cet, Ct
                        let Ce = [C[0], C[1], C[5], C[1], C[7], C[11], C[5], C[11], C[35]]
                        let Cet = [C[2], C[3], C[4], C[8], C[9], C[10], C[17], C[23], C[29]]
                        let Ct = [C[14], C[15], C[16], C[15], C[21], C[22], C[16], C[22], C[28]]
                        
                        // Get Q
                        var Q = [Double](repeating: 0.0, count: 9)
                        let CtI = invert(matrix: Ct)
                        var CetT = [Double](repeating: 0.0, count: 9)
                        vDSP_mtransD(Cet, 1, &CetT, 1, 3, 3)
                        
                        var temp2 = [Double](repeating: 0.0, count: 9)
                        var temp3 = [Double](repeating: 0.0, count: 9)
                        vDSP_mmulD(Cet,1,CtI,1,&temp2,1,3,3,3)
                        vDSP_mmulD(temp2,1,CetT,1,&temp3,1,3,3,3)
                        vDSP_vsubD(temp3, 1, Ce, 1, &Q, 1, 9)
                        
                        // Get tempCts, Qs, tempCets
                        vDSP_vaddD(Qs, 1, Q, 1, &Qs, 1, 9)
                        vDSP_vaddD(tempCts, 1, CtI, 1, &tempCts, 1, 9)
                        var temp4 = [Double](repeating: 0.0, count: 9)
                        vDSP_mmulD(Cet,1,CtI,1,&temp4,1,3,3,3)
                        vDSP_vaddD(tempCets, 1, temp4, 1, &tempCets, 1, 9)
                    }
                    
                    // Get average tempCts, Qs, tempCets
                    var nPlyD = Double(nPly)
                    vDSP_vsdivD(Qs, 1, &nPlyD, &Qs, 1, 9)
                    vDSP_vsdivD(tempCts, 1, &nPlyD, &tempCts, 1, 9)
                    vDSP_vsdivD(tempCets, 1, &nPlyD, &tempCets, 1, 9)

                    
                    // Get Cts, Cets, Cet
                    Cts = invert(matrix: tempCts)
                    vDSP_mmulD(tempCets,1,Cts,1,&Cets,1,3,3,3)
                    let CtsI = invert(matrix: Cts)
                    var CetsT = [Double](repeating: 0.0, count: 9)
                    vDSP_mtransD(Cets, 1, &CetsT, 1, 3, 3)
                    var temp5 = [Double](repeating: 0.0, count: 9)
                    vDSP_mmulD(Cets,1,CtsI,1,&temp5,1,3,3,3)
                    var temp6 = [Double](repeating: 0.0, count: 9)
                    vDSP_mmulD(temp5,1,CetsT,1,&temp6,1,3,3,3)
                    vDSP_vaddD(Qs, 1, temp6, 1, &Ces, 1, 9)

                    //Get Cs
                    let Cs = [Ces[0], Ces[1], Cets[0], Cets[1], Cets[2], Ces[2], Ces[3], Ces[4], Cets[3], Cets[4], Cets[5], Ces[5], Cets[0], Cets[3], Cts[0], Cts[1], Cts[2], Cets[6], Cets[1], Cets[4], Cts[1], Cts[4], Cts[7], Cets[7], Cets[2], Cets[5], Cts[2], Cts[5], Cts[8], Cets[8], Ces[6], Ces[7], Cets[6], Cets[7], Cets[8], Ces[8]]
                    
                    let Ss = invert(matrix: Cs)
                    
                    // Effective 3D properties
                    effective3DProperties[0] = 1/Ss[0]
                    effective3DProperties[1] = 1/Ss[7]
                    effective3DProperties[2] = 1/Ss[14]
                    effective3DProperties[3] = 1/Ss[21]
                    effective3DProperties[4] = 1/Ss[28]
                    effective3DProperties[5] = 1/Ss[35]
                    effective3DProperties[6] = -1/Ss[0]*Ss[1]
                    effective3DProperties[7] = -1/Ss[0]*Ss[2]
                    effective3DProperties[8] = -1/Ss[7]*Ss[8]
                
                    // Calculate A, B, and D matrices
                    let Sep : [Double] = [1/e1, -v12/e1, 0, -v12/e1, 1/e2, 0, 0, 0, 1/g12]
                    let Qep = invert(matrix: Sep)
                    var A = [Double](repeating: 0.0, count: 9)
                    var B = [Double](repeating: 0.0, count: 9)
                    var D = [Double](repeating: 0.0, count: 9)
                    for i in 1...nPly {
                        let c = cos(layupSequence[i-1] * Double.pi / 180)
                        let s = sin(layupSequence[i-1] * Double.pi / 180)
                        let Rsigmae = [c*c, s*s, -2*s*c, s*s, c*c, 2*s*c, s*c, -s*c, c*c-s*s]
                        var RsigmaeT = [Double](repeating: 0.0, count: 9)
                        vDSP_mtransD(Rsigmae, 1, &RsigmaeT, 1, 3, 3)

                        var Qe = [Double](repeating: 0.0, count: 9)
                        var Atemp = [Double](repeating: 0.0, count: 9)
                        var Btemp = [Double](repeating: 0.0, count: 9)
                        var Dtemp = [Double](repeating: 0.0, count: 9)

                        var temp1 = [Double](repeating: 0.0, count: 9)
                        vDSP_mmulD(Rsigmae,1,Qep,1,&temp1,1,3,3,3)
                        vDSP_mmulD(temp1,1,RsigmaeT,1,&Qe,1,3,3,3)

                        vDSP_vsmulD(Qe, 1, &t, &Atemp, 1, 9)

                        var temp2 = bzi[i-1]*t
                        vDSP_vsmulD(Qe, 1, &temp2, &Btemp, 1, 9)

                        var temp3 = t*bzi[i-1]*bzi[i-1] + pow(t, 3.0)/12
                        vDSP_vsmulD(Qe, 1, &temp3, &Dtemp, 1, 9)

                        vDSP_vaddD(A, 1, Atemp, 1, &A, 1, 9)
                        vDSP_vaddD(B, 1, Btemp, 1, &B, 1, 9)
                        vDSP_vaddD(D, 1, Dtemp, 1, &D, 1, 9)
                    }
                    
                    let ABD = [A[0], A[1], A[2], B[0], B[1], B[2], A[3], A[4], A[5], B[3], B[4], B[5], A[6], A[7], A[8], B[6], B[7], B[8], B[0], B[3], B[6], D[0], D[1], D[2], B[1], B[4], B[7], D[3], D[4], D[5], B[2], B[5], B[8], D[6], D[7], D[8]]
                    
                    var abd = invert(matrix: ABD)
                    
                    var h = nPlyD * t
                    
                    let AI = [abd[0], abd[1], abd[2], abd[6], abd[7], abd[8], abd[12], abd[13], abd[14]]
                    
                    let DI = [abd[21], abd[22], abd[23], abd[27], abd[28], abd[29], abd[33], abd[34], abd[35]]
                    
                    var Ses = [Double](repeating: 0.0, count: 9)
                    vDSP_vsmulD(AI, 1, &h, &Ses, 1, 9)
                    
                    var Sesf = [Double](repeating: 0.0, count: 9)
                    var temph = pow(h, 3.0) / 12.0
                    vDSP_vsmulD(DI, 1, &temph, &Sesf, 1, 9)
                    
                    effectiveInplaneProperties[0] = 1/Ses[0]
                    effectiveInplaneProperties[1] = 1/Ses[4]
                    effectiveInplaneProperties[2] = 1/Ses[8]
                    effectiveInplaneProperties[3] = -1/Ses[0]*Ses[1]
                    effectiveInplaneProperties[4] = 1/Ses[8]*Ses[2]
                    effectiveInplaneProperties[5] = 1/Ses[8]*Ses[5]
                    
                    effectiveFlexuralProperties[0] = 1/Sesf[0]
                    effectiveFlexuralProperties[1] = 1/Sesf[4]
                    effectiveFlexuralProperties[2] = 1/Sesf[8]
                    effectiveFlexuralProperties[3] = -1/Sesf[0]*Sesf[1]
                    effectiveFlexuralProperties[4] = 1/Sesf[8]*Sesf[2]
                    effectiveFlexuralProperties[5] = 1/Sesf[8]*Sesf[5]
                    
                }
                else {
                    self.present(alter, animated: true, completion: nil)
                    return false
                }
            }
            else {
                self.present(alter, animated: true, completion: nil)
                return false
            }
        }
        else {
            self.present(alter, animated: true, completion: nil)
            return false
        }
        
        return true
    }

}



