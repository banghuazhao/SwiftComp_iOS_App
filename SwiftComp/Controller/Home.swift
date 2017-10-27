//
//  Home.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class Home: UITableViewController {
    
    var compositeModels: [CompositeModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .black
        
        navigationItem.title = "Composite Models"
        
        tableView.register(CompositeModelCell.self, forCellReuseIdentifier: "cellID")
        
        setupCompositeModels()
        
        tableView.tableFooterView = UIView()

    }

    func setupCompositeModels() {
        let compositeModel1 = CompositeModel(name: "Laminate", image: #imageLiteral(resourceName: "laminate"))
        let compositeModel2 = CompositeModel(name: "Unidirectional Fiber Reinforced Composite", image: #imageLiteral(resourceName: "spuarePack"))
        
        self.compositeModels = [compositeModel1, compositeModel2]
    }

    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = compositeModels?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompositeModelCell
        
        let compositeModel = compositeModels?[indexPath.row]
        
        cell.compositeModel = compositeModel
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "test", sender: self)
        default:
            return
        }
        
    }
    

}




extension UIButton {
    func applyDesign() {
        self.setTitleColor(self.tintColor, for: .normal)
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 240/255, alpha: 1.0)
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2
        
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        
        flash.duration = 0.2
        flash.fromValue = 0.6
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.add(flash, forKey: nil)
    }
}


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




extension UIView {
    func cardViewDesign() {
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 223/255, green: 220/255, blue: 194/255, alpha: 1.0).cgColor
    }
}
extension UILabel {
    func cardViewDesignForLabel() {
        self.backgroundColor = UIColor(red: 254/255, green: 248/255, blue: 223/255, alpha: 1.0)
        self.textColor = UIColor(red: 130/255, green: 138/255, blue: 145/255, alpha: 1.0)
        self.textAlignment = .center
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.font = UIFont.systemFont(ofSize: 14)
    
    }
}
extension UITextField {
    func cardViewDesignForTextView() {
        self.backgroundColor = UIColor.white
        self.borderStyle = .roundedRect
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.font = UIFont.systemFont(ofSize: 14)
        
    }
}




extension UIView {
    func resultViewDesign() {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
