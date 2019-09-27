//
//  ButtonDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import FontAwesome_swift

private var pTouchAreaEdgeInsets: UIEdgeInsets = .zero

extension UIButton {
    
    var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &pTouchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }
            else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &pTouchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.touchAreaEdgeInsets == .zero || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.touchAreaEdgeInsets)
        
        return hitFrame.contains(point)
    }
}



extension UIButton {
    
    func marketSectionButton(under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitleColor(self.tintColor, for: .normal)
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 12).isActive = true
        self.widthAnchor.constraint(equalTo: under.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    func shareButtonDesign(under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        self.setTitle(String.fontAwesomeIcon(name: .shareSquare), for: UIControl.State.normal)
        
        self.setTitleColor(self.tintColor, for: .normal)
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 2).isActive = true
        self.rightAnchor.constraint(equalTo: under.rightAnchor, constant: -6).isActive = true
        
        self.touchAreaEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    }
    
    func questionButtonDesign(under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
        self.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: UIControl.State.normal)
        
        self.setTitleColor(self.tintColor, for: .normal)
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 2).isActive = true
        self.rightAnchor.constraint(equalTo: under.rightAnchor, constant: -6).isActive = true
        
        self.touchAreaEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    }
    
    func methodButtonDesign(under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        
        self.setTitleColor(self.tintColor, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 38).isActive = true
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.touchAreaEdgeInsets = UIEdgeInsets(top: -12, left: -24, bottom: -12, right: -24)
    }
    
    
    
    func dataBaseButtonDesign(under: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let str = String.fontAwesomeIcon(name: .database) + " Database"
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = self.tintColor
        let attributedStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        //Apply FontAwesome to the first character
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 14, style: .solid),
                                   range: range1)
        //Apply the system font to the rest of the string
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.systemFont(ofSize: 14),
                                   range: range2)
        
        self.setAttributedTitle(attributedStr, for: .normal)
        self.titleLabel?.textAlignment = .center
        
        
        self.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 240/255, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: -59.5).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 36).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
    }
    
    func saveButtonDesign(under: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let str = String.fontAwesomeIcon(name: .save) + " Save"
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = self.tintColor
        let attributedStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        //Apply FontAwesome to the first character
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 14, style: .solid),
                                   range: range1)
        //Apply the system font to the rest of the string
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.systemFont(ofSize: 14),
                                   range: range2)
        
        self.setAttributedTitle(attributedStr, for: .normal)
        self.titleLabel?.textAlignment = .center
        
        self.backgroundColor = UIColor(red: 226/255, green: 234/255, blue: 240/255, alpha: 1.0)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor, constant: 59.5).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 36).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func cloudCalculateButtonDesign(vc: UIViewController, calculateFunction: Selector) {
        
        if self.translatesAutoresizingMaskIntoConstraints  {
            self.translatesAutoresizingMaskIntoConstraints = false
        
            self.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
            self.titleLabel?.textAlignment = .center
            self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            self.removeTarget(nil, action: nil, for: .allEvents)
        }
        let str = String.fontAwesomeIcon(name: .cloud) + " Calculate      "
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        let attributedStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        //Apply FontAwesome to the first character
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 16, style: .solid),
                                   range: range1)
        //Apply the system font to the rest of the string
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.systemFont(ofSize: 16),
                                   range: range2)
        
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(attributedStr, for: .normal)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.backgroundColor = UIColor(red: 129/255, green: 197/255, blue: 72/255, alpha: 1.0)
        self.addTarget(vc, action: calculateFunction, for: .touchUpInside)
    }
    
    func cloudCalculateNoInternetButtonDesign(vc: UIViewController, calculateFunction: Selector) {
        if self.translatesAutoresizingMaskIntoConstraints  {
            self.translatesAutoresizingMaskIntoConstraints = false
            
            self.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
            self.titleLabel?.textAlignment = .center
            self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            self.removeTarget(nil, action: nil, for: .allEvents)
        }
        let str = String.fontAwesomeIcon(name: .cloud) + " Calculate      "
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        let attributedStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        //Apply FontAwesome to the first character
        let range1 = NSRange(location: 0, length: 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.fontAwesome(ofSize: 16, style: .solid),
                                   range: range1)
        //Apply the system font to the rest of the string
        let range2 = NSRange(location: 1, length: (str as NSString).length - 1)
        attributedStr.addAttribute(.font,
                                   value: UIFont.systemFont(ofSize: 16),
                                   range: range2)
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(attributedStr, for: .normal)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.backgroundColor = .gray
        self.addTarget(vc, action: calculateFunction, for: .touchUpInside)
    }
    
    
    func calculateButtonDesign(vc: UIViewController, calculateFunction: Selector) {
        if self.translatesAutoresizingMaskIntoConstraints {
            self.translatesAutoresizingMaskIntoConstraints = false
        
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.tintColor = .white
            self.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
            self.titleLabel?.textAlignment = .center
            self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            self.removeTarget(nil, action: nil, for: .allEvents)
        }
        self.setAttributedTitle(nil, for: .normal)
        self.setTitle("Calculate", for: UIControl.State.normal)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        self.backgroundColor = UIColor(red: 129/255, green: 197/255, blue: 72/255, alpha: 1.0)
        self.addTarget(vc, action: calculateFunction, for: .touchUpInside)
    }
    
    func swiftCompOutputButtonDesign(under: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle("Show SwiftComp Output", for: UIControl.State.normal)
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
        
        self.backgroundColor = UIColor(red: 244/255, green: 128/255, blue: 35/255, alpha: 1.0)
        self.layer.cornerRadius = self.intrinsicContentSize.height / 2.5
        
        self.tintColor = .white
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.heightAnchor.constraint(equalToConstant: 28).isActive = true
        self.topAnchor.constraint(equalTo: under.topAnchor, constant: 36).isActive = true
        self.centerXAnchor.constraint(equalTo: under.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: self.intrinsicContentSize.width + 40).isActive = true
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        
        flash.duration = 0.2
        flash.fromValue = 0.6
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        layer.add(flash, forKey: nil)
    }
}

