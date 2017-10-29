//
//  TableHeader.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/29/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit

class TableHeader: UITableViewHeaderFooterView {
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.addSubview(headerView)
        headerView.backgroundColor = UIColor.clear
        headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        headerView.addSubview(headerLabel)
        
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, constant: 0).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
