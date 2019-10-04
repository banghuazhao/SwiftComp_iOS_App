//
//  utilities.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/20/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import Foundation
import Accelerate
import UIKit
import CoreData


extension UIView {
    
    // autolayout for UIView
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
    
    // variadic arguments for addSubviews
    
    func addSubviews(_ views: UIView...) {
        views.forEach {addSubview($0)}
    }
    
}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

// Inverse operation for matrix

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


// fill results for result card

func fillResults(resultItems: [Double], resultLabel: [UILabel]) {
    
    for i in 0...resultItems.count-1 {
        
        if abs(resultItems[i]) >= 1e6 {
            resultLabel[i].text = String(format: "%.3e", resultItems[i])
        } else if abs(resultItems[i]) >= 0.001 {
            resultLabel[i].text = String(format: "%.3f", resultItems[i])
        }  else {
            resultLabel[i].text = String(format: "%.3e", resultItems[i])
        }
        
        if (resultItems[i] == 0) {
            resultLabel[i].text = "0"
        }
        
        resultLabel[i].adjustsFontSizeToFitWidth = true
    }
    
}

func fillResultsRoundSmall(resultItems: [Double], resultLabel: [UILabel], max: Double) {
    
    for i in 0...resultItems.count-1 {
        
        if abs(resultItems[i]) >= 1e6 {
            resultLabel[i].text = String(format: "%.3e", resultItems[i])
        } else if abs(resultItems[i]) >= 0.001 {
            resultLabel[i].text = String(format: "%.3f", resultItems[i])
        }  else {
            resultLabel[i].text = String(format: "%.3e", resultItems[i])
        }
        
        if (resultItems[i] != 0) {
            if abs(max/resultItems[i]) > 1e12 {
                resultLabel[i].text = "0"
            }
        } else {
            resultLabel[i].text = "0"
        }
        
        resultLabel[i].adjustsFontSizeToFitWidth = true
    }
    
}

// change the background color of a UIButton while it's highlighted

extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                alpha = 0.5
            }
            else {
                alpha = 1
            }
        }
    }
}


// Calculate string size, width, or height

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}


func clearCoreDataStore() {
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    for i in 0...CoreDataManager.shared.persistentContainer.managedObjectModel.entities.count-1 {
        let entity = CoreDataManager.shared.persistentContainer.managedObjectModel.entities[i]
        
        do {
            let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleterequest = NSBatchDeleteRequest(fetchRequest: query)
            try context.execute(deleterequest)
            try context.save()
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            abort()
        }
    }
}




func getlayupSequence(textFieldValue: String) -> [Double] {
    
    var rBefore : Int = 1
    var rAfter : Int = 1
    var symmetry : Int = 1
    var baseLayup : String
    var baseLayupSequence = [Double]()
    var layupSequence = [Double]()
    var nPly : Int = 0
    
    // Handle stacking sequence
    
    if textFieldValue == "" {
        return []
    }
        
    let str = textFieldValue
    
    if str.split(separator: "]").count == 2 {
        baseLayup = str.split(separator: "]")[0].replacingOccurrences(of: "[", with: "")
        let rsr = str.split(separator: "]")[1]
        if rsr.split(separator: "s").count == 2 {
            symmetry = 2
            if let i = Int(rsr.split(separator: "s")[0]), let j = Int(rsr.split(separator: "s")[1]) {
                rBefore = i
                rAfter = j
            } else {
                return []
            }
        } else if rsr.contains("s") {
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
                    } else {
                        return []
                    }
                } else {
                    return []
                }
            } else {
                rAfter = 1
                if let i = Int(rsr.split(separator: "s")[0]) {
                    rBefore = i
                } else {
                    return []
                }
            }
        } else {
            symmetry = 1
            rBefore = 1
            if let i = Int(rsr) {
                rAfter = i
            } else {
                return []
            }
        }
    } else {
        baseLayup = str.replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")
        rBefore = 1
        rAfter = 1
        symmetry = 1
    }
    
    for i in baseLayup.components(separatedBy: "/") {
        if let j = Double(i) {
            baseLayupSequence.append(j)
        } else {
            return []
        }
    }
    
    nPly = baseLayupSequence.count * rBefore * symmetry * rAfter
    
    if nPly > 0 {
        
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
    } else {
        return []
    }
    
    return layupSequence
    
}



/*
 
// Transition

let transition = CircleTransitionDesign()
var touchLocation: CGPoint = CGPoint.zero
 

// Add transition animation

func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    transition.startingPoint = touchLocation
    
    if operation == .push {
        transition.transitionMode = .present
        switch toVC {
        case LaminateStackingSequenceDataBaseViewController:
            transition.circleColor = stackingSequenceDataBase.backgroundColor!
        case laminateLaminaMaterialDataBaseViewController:
            transition.circleColor = laminaMaterialDataBase.backgroundColor!
        default:
            return nil
        }
    } else {
        transition.transitionMode = .dismiss
        switch fromVC {
        case LaminateStackingSequenceDataBaseViewController:
            transition.circleColor = stackingSequenceDataBase.backgroundColor!
        case laminateLaminaMaterialDataBaseViewController:
            transition.circleColor = laminaMaterialDataBase.backgroundColor!
        default:
            return nil
        }
    }
    
    return transition
    
}
 
*/

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}


func createPath(beginPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: beginPoint)
    path.addLine(to: endPoint)
    return path
}


extension UIViewController {
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
