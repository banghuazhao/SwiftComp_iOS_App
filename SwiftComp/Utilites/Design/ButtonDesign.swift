//
//  ButtonDesign.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/31/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

private var pTouchAreaEdgeInsets: UIEdgeInsets = .zero

extension UIButton {
    var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &pTouchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            } else {
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
        if touchAreaEdgeInsets == .zero || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = bounds
        let hitFrame = relativeFrame.inset(by: touchAreaEdgeInsets)

        return hitFrame.contains(point)
    }
}

extension UIButton {
    func marketSectionButton(under: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        setTitleColor(tintColor, for: .normal)
        topAnchor.constraint(equalTo: under.topAnchor, constant: 12).isActive = true
        widthAnchor.constraint(equalTo: under.widthAnchor, multiplier: 0.2).isActive = true
    }

    func shareButtonDesign(under: UIView) {
        setImage(UIImage(named: "share"), for: .normal)

        snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.height.width.equalTo(18)
        }

        touchAreaEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    }

    func questionButtonDesign(under: UIView) {
        setImage(UIImage(named: "info"), for: .normal)

        snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(8)
            make.height.width.equalTo(18)
        }

        touchAreaEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    }

    func methodButtonDesign(under: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1.0)
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor

        setTitleColor(tintColor, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.adjustsFontSizeToFitWidth = true

        let imageView = UIImageView(image: UIImage(named: "more"))
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }

        heightAnchor.constraint(equalToConstant: 32).isActive = true
        topAnchor.constraint(equalTo: under.topAnchor, constant: 38).isActive = true
        centerXAnchor.constraint(equalTo: under.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: 260).isActive = true

        touchAreaEdgeInsets = UIEdgeInsets(top: -12, left: -24, bottom: -12, right: -24)
    }

    func dataBaseButtonDesign(under: UIView) {
        let title = UILabel()
        title.text = "Database"
        title.textColor = tintColor
        title.font = UIFont.systemFont(ofSize: 14)
        let imageView = UIImageView(image: UIImage(named: "database"))

        addSubview(title)
        addSubview(imageView)

        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.centerY.equalTo(title)
            make.right.equalTo(title.snp.left).offset(-16)
        }

        backgroundColor = UIColor(red: 226 / 255, green: 234 / 255, blue: 240 / 255, alpha: 1.0)
        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.height.equalTo(30)
            make.width.equalTo(140)
            make.centerX.equalToSuperview().offset(-69.5)
        }
    }

    func saveButtonDesign(under: UIView) {
        let title = UILabel()
        title.text = "Save"
        title.textColor = tintColor
        title.font = UIFont.systemFont(ofSize: 14)
        let imageView = UIImageView(image: UIImage(named: "save"))

        addSubview(title)
        addSubview(imageView)

        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.centerY.equalTo(title)
            make.right.equalTo(title.snp.left).offset(-16)
        }

        backgroundColor = UIColor(red: 226 / 255, green: 234 / 255, blue: 240 / 255, alpha: 1.0)
        layer.cornerRadius = intrinsicContentSize.height / 2
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        layer.borderWidth = 1
        layer.borderColor = tintColor.cgColor

        snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.height.equalTo(30)
            make.width.equalTo(140)
            make.centerX.equalToSuperview().offset(69.5)
        }
    }

    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func swiftCompOutputButtonDesign(under: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        setTitle("Show SwiftComp Calculation Info", for: UIControl.State.normal)
        frame = CGRect(x: 0, y: 0, width: 280, height: 32)

        backgroundColor = UIColor(red: 244 / 255, green: 128 / 255, blue: 35 / 255, alpha: 1.0)
        layer.cornerRadius = intrinsicContentSize.height / 2.5

        tintColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 15)

        heightAnchor.constraint(equalToConstant: 28).isActive = true
        topAnchor.constraint(equalTo: under.topAnchor, constant: 36).isActive = true
        centerXAnchor.constraint(equalTo: under.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: intrinsicContentSize.width + 40).isActive = true
    }
}
