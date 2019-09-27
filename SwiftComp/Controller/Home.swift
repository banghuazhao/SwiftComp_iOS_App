//
//  Home.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/4/17.
//  Copyright © 2017 Banghua Zhao. All rights reserved.
//

import UIKit
import CoreData

class Home: UIViewController, UIGestureRecognizerDelegate {
    
    var scrollView = UIScrollView()
    
    // market section
    
    var marketView: UIView = UIView()
    
    var aboutButton: UIButton = UIButton()
    var aboutLabel: UILabel = UILabel()
    
    var theoryButton: UIButton = UIButton()
    var theoryLabel: UILabel = UILabel()
    
    var helpButton: UIButton = UIButton()
    var helpLabel: UILabel = UILabel()
    
    var userManualButton: UIButton = UIButton()
    var userManualLabel: UILabel = UILabel()
    
    // composite models
    
    var compositeModelsView: UIView = UIView()
    
    var compositeModelsTableView = UITableView()
    
    var compositeModels = CompoisteModels()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .greybackgroundColor
        
        // enable swipe right to go back
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        createLayout()
        
        // clearCoreDataStore()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        editNavigationBar()
        
    }
    
    
    // MARK: set up navigation bar
    
    func editNavigationBar() {        
        navigationItem.title = "Home"
        
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "trade_mark"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
        
        self.navigationController?.setToolbarHidden(true, animated: false)

    }
    
    
    func createLayout() {
        self.view.addSubview(scrollView)
        
        scrollView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        scrollView.addSubview(marketView)
        scrollView.addSubview(compositeModelsView)
        
        // makert
        
        createViewCardWithoutTitle(viewCard: marketView, aboveConstraint: scrollView.topAnchor, under: scrollView)
        marketView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let marketViewUnitWidth = (UIScreen.main.bounds.width - 24) * 0.01
        
        marketView.addSubview(aboutButton)
        marketView.addSubview(aboutLabel)
        
        aboutButton.marketSectionButton(under: marketView)
        aboutButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        aboutButton.sizeToFit()
        aboutButton.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: UIControl.State.normal)
        aboutButton.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: -36 * marketViewUnitWidth).isActive = true
        aboutButton.addTarget(self, action: #selector(showAbout), for: .touchUpInside)
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.text = "About"
        aboutLabel.font = UIFont.systemFont(ofSize: 14)
        aboutLabel.textAlignment = .center
        aboutLabel.centerYAnchor.constraint(equalTo: marketView.centerYAnchor, constant: 28).isActive = true
        aboutLabel.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: -36 * marketViewUnitWidth).isActive = true
        aboutLabel.widthAnchor.constraint(equalToConstant: 20 * marketViewUnitWidth).isActive = true
        aboutLabel.adjustsFontSizeToFitWidth = true
        
        marketView.addSubview(theoryButton)
        marketView.addSubview(theoryLabel)
        
        theoryButton.marketSectionButton(under: marketView)
        theoryButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        aboutButton.sizeToFit()
        theoryButton.setTitle(String.fontAwesomeIcon(name: .bookOpen), for: UIControl.State.normal)
        theoryButton.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: -12 * marketViewUnitWidth).isActive = true
        theoryButton.addTarget(self, action: #selector(showTheory), for: .touchUpInside)
        
        theoryLabel.translatesAutoresizingMaskIntoConstraints = false
        theoryLabel.text = "Theory"
        theoryLabel.font = UIFont.systemFont(ofSize: 14)
        theoryLabel.textAlignment = .center
        theoryLabel.centerYAnchor.constraint(equalTo: marketView.centerYAnchor, constant: 28).isActive = true
        theoryLabel.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: -12 * marketViewUnitWidth).isActive = true
        theoryLabel.widthAnchor.constraint(equalToConstant: 20 * marketViewUnitWidth).isActive = true
        theoryLabel.adjustsFontSizeToFitWidth = true
        
        
        marketView.addSubview(helpButton)
        marketView.addSubview(helpLabel)
        
        helpButton.marketSectionButton(under: marketView)
        helpButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        helpButton.sizeToFit()
        helpButton.setTitle(String.fontAwesomeIcon(name: .questionCircle), for: UIControl.State.normal)
        helpButton.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: 12 * marketViewUnitWidth).isActive = true
        helpButton.addTarget(self, action: #selector(showHelp), for: .touchUpInside)
        
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.text = "Help"
        helpLabel.font = UIFont.systemFont(ofSize: 14)
        helpLabel.textAlignment = .center
        helpLabel.centerYAnchor.constraint(equalTo: marketView.centerYAnchor, constant: 28).isActive = true
        helpLabel.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: 12 * marketViewUnitWidth).isActive = true
        helpLabel.widthAnchor.constraint(equalToConstant: 20 * marketViewUnitWidth).isActive = true
        helpLabel.adjustsFontSizeToFitWidth = true
        
        marketView.addSubview(userManualButton)
        marketView.addSubview(userManualLabel)
        
        userManualButton.marketSectionButton(under: marketView)
        userManualButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 45, style: .solid)
        userManualButton.sizeToFit()
        userManualButton.setTitle(String.fontAwesomeIcon(name: .filePdf), for: UIControl.State.normal)
        userManualButton.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: 36 * marketViewUnitWidth).isActive = true
        userManualButton.addTarget(self, action: #selector(showUserManual), for: .touchUpInside)
        
        userManualLabel.translatesAutoresizingMaskIntoConstraints = false
        userManualLabel.text = "User Manual"
        userManualLabel.font = UIFont.systemFont(ofSize: 14)
        userManualLabel.textAlignment = .center
        userManualLabel.centerYAnchor.constraint(equalTo: marketView.centerYAnchor, constant: 28).isActive = true
        userManualLabel.centerXAnchor.constraint(equalTo: marketView.centerXAnchor, constant: 36 * marketViewUnitWidth).isActive = true
        userManualLabel.widthAnchor.constraint(equalToConstant: 20 * marketViewUnitWidth).isActive = true
        userManualLabel.adjustsFontSizeToFitWidth = true
        
        
        // composite models
        
        createViewCard(viewCard: compositeModelsView, title: "Composite Models", aboveConstraint: marketView.bottomAnchor, under: scrollView)
        compositeModelsView.addSubview(compositeModelsTableView)
        
        compositeModelsTableView.translatesAutoresizingMaskIntoConstraints = false
        compositeModelsTableView.topAnchor.constraint(equalTo: compositeModelsView.topAnchor, constant: 30).isActive = true
        compositeModelsTableView.leftAnchor.constraint(equalTo: compositeModelsView.leftAnchor, constant: 0).isActive = true
        compositeModelsTableView.rightAnchor.constraint(equalTo: compositeModelsView.rightAnchor, constant: 0).isActive = true
        compositeModelsTableView.bottomAnchor.constraint(equalTo: compositeModelsView.bottomAnchor, constant: -12).isActive = true
        let compositeModelTableViewTotalHeight : CGFloat = CGFloat(compositeModels.models.count * 86)
        compositeModelsTableView.heightAnchor.constraint(equalToConstant: compositeModelTableViewTotalHeight).isActive = true
        compositeModelsTableView.isScrollEnabled = false
        compositeModelsTableView.delegate = self
        compositeModelsTableView.dataSource = self
        compositeModelsTableView.register(CompositeModelCell.self, forCellReuseIdentifier: "cellID")
        compositeModelsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: compositeModelsTableView.frame.size.width, height: 1))
        
        compositeModelsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        
    }
    
    
    // market section
    
    @objc func showAbout(_ sender: UIButton) {
        sender.flash()
        self.navigationController?.pushViewController(HomeAbout(), animated: true)
    }
    
    @objc func showTheory(_ sender: UIButton) {
        sender.flash()
        self.navigationController?.pushViewController(HomeTheory(), animated: true)
    }
    
    @objc func showHelp(_ sender: UIButton) {
        sender.flash()
        self.navigationController?.pushViewController(HomeHelp(), animated: true)
    }
    
    @objc func showUserManual(_ sender: UIButton) {
        sender.flash()
        self.navigationController?.pushViewController(HomeUserManual(), animated: true)
    }
    
    
}


// self delegate to UITableView

extension Home: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compositeModels.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = compositeModelsTableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CompositeModelCell
        
        let compositeModel = compositeModels.models[indexPath.row]
        
        cell.compositeModel = compositeModel
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        compositeModelsTableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        switch indexPath.row {
        case 0:
            let laminateViewController = Laminate()
            self.navigationController?.pushViewController(laminateViewController, animated: true)
        case 1:
            let UDFRCViewController = UDFRC()
            self.navigationController?.pushViewController(UDFRCViewController, animated: true)
        case 2:
            let honeycombSandwichViewController = HoneycombSandwich()
            self.navigationController?.pushViewController(honeycombSandwichViewController, animated: true)
        default:
            return
        }
        
    }
    
}
















