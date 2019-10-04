//
//  HomeTheory.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/30/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class TheoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteThemeColor
        
        self.navigationItem.title = "Theory"
        
        editLayout()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    
    func editLayout() {
        
        let scrollView: UIScrollView = UIScrollView()
        
        self.view.addSubview(scrollView)
        
        scrollView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        
        // title
        
        let brandTitle: UITextView = UITextView()
        
        scrollView.addSubview(brandTitle)

        brandTitle.translatesAutoresizingMaskIntoConstraints = false
        brandTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        brandTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        brandTitle.text = "Theory"
        brandTitle.font = UIFont.boldSystemFont(ofSize: 20)
        brandTitle.isScrollEnabled = false
        brandTitle.isEditable = false
        brandTitle.backgroundColor = .whiteThemeColor
        brandTitle.textColor = .blackThemeColor
        
        
        // structural model
        
        let structuralModelTitle: UITextView = UITextView()
        let structuralModelText: UITextView = UITextView()
        let structuralModelImage: UIImageView = UIImageView()
        
        scrollView.addSubview(structuralModelTitle)
        scrollView.addSubview(structuralModelText)
        scrollView.addSubview(structuralModelImage)
        
        structuralModelTitle.translatesAutoresizingMaskIntoConstraints = false
        structuralModelTitle.topAnchor.constraint(equalTo: brandTitle.bottomAnchor, constant: 24).isActive = true
        structuralModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structuralModelTitle.text = "Structural Models"
        structuralModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        structuralModelTitle.isScrollEnabled = false
        structuralModelTitle.isEditable = false
        structuralModelTitle.backgroundColor = .whiteThemeColor
        structuralModelTitle.textColor = .blackThemeColor
        
        structuralModelText.translatesAutoresizingMaskIntoConstraints = false
        structuralModelText.topAnchor.constraint(equalTo: structuralModelTitle.bottomAnchor, constant: 6).isActive = true
        structuralModelText.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structuralModelText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        structuralModelText.font = UIFont.systemFont(ofSize: 14)
        structuralModelText.isScrollEnabled = false
        structuralModelText.isEditable = false
        structuralModelText.dataDetectorTypes = UIDataDetectorTypes.all
        structuralModelText.text = """
        ● If one dimension of the structure is much larger than two other dimensions, the structure is called as a beam. We can use beam elements to model this structure.
        ● If one dimension of the structure is much smaller than the two other dimensions, the structure is called as a plate. We can use plate elements to model this structure.
        ● If the three dimensions of a structure are of similar size, it is called a 3D structure. We can use solid elements to model this structure.
        """
        structuralModelText.textAlignment = .justified
        structuralModelText.backgroundColor = .whiteThemeColor
        structuralModelText.textColor = .blackThemeColor
        
        structuralModelImage.translatesAutoresizingMaskIntoConstraints = false
        structuralModelImage.topAnchor.constraint(equalTo: structuralModelText.bottomAnchor, constant: 8).isActive = true
        structuralModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        structuralModelImage.heightAnchor.constraint(equalToConstant: 85).isActive = true
        structuralModelImage.contentMode = .scaleAspectFit
        structuralModelImage.clipsToBounds = true
        structuralModelImage.image = #imageLiteral(resourceName: "theory_structure_model")
        
        // beam model
        
        let beamModelTitle: UITextView = UITextView()
        let beamModelText1: UITextView = UITextView()
        let eulerBernoulliBeamModelImage: UIImageView = UIImageView()
        let beamModelText2: UITextView = UITextView()
        let timoshenkoBeamModelImage: UIImageView = UIImageView()
        
        scrollView.addSubview(beamModelTitle)
        scrollView.addSubview(beamModelText1)
        scrollView.addSubview(eulerBernoulliBeamModelImage)
        scrollView.addSubview(beamModelText2)
        scrollView.addSubview(timoshenkoBeamModelImage)
        
        beamModelTitle.translatesAutoresizingMaskIntoConstraints = false
        beamModelTitle.topAnchor.constraint(equalTo: structuralModelImage.bottomAnchor, constant: 24).isActive = true
        beamModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        beamModelTitle.text = "Beam Model"
        beamModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        beamModelTitle.isScrollEnabled = false
        beamModelTitle.isEditable = false
        beamModelTitle.backgroundColor = .whiteThemeColor
        beamModelTitle.textColor = .blackThemeColor
        
        beamModelText1.translatesAutoresizingMaskIntoConstraints = false
        beamModelText1.topAnchor.constraint(equalTo: beamModelTitle.bottomAnchor, constant: 6).isActive = true
        beamModelText1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        beamModelText1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        beamModelText1.font = UIFont.systemFont(ofSize: 14)
        beamModelText1.isScrollEnabled = false
        beamModelText1.isEditable = false
        beamModelText1.dataDetectorTypes = UIDataDetectorTypes.all
        beamModelText1.text = """
        For a structural is modeled as a beam, we need to use beam constitutive relations.
        The beam constitutive relations of the Euler-Bernoulli beam model can be expressed using the following four equations and the 4 by 4 matrix is commonly called the beam stiffness matrix.
        """
        beamModelText1.textAlignment = .justified
        beamModelText1.backgroundColor = .whiteThemeColor
        beamModelText1.textColor = .blackThemeColor
        
        eulerBernoulliBeamModelImage.translatesAutoresizingMaskIntoConstraints = false
        eulerBernoulliBeamModelImage.topAnchor.constraint(equalTo: beamModelText1.bottomAnchor, constant: 8).isActive = true
        eulerBernoulliBeamModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        eulerBernoulliBeamModelImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        eulerBernoulliBeamModelImage.contentMode = .scaleAspectFit
        eulerBernoulliBeamModelImage.clipsToBounds = true
        eulerBernoulliBeamModelImage.image = #imageLiteral(resourceName: "theory_eulerBernoulli_beam_model")
        
        beamModelText2.translatesAutoresizingMaskIntoConstraints = false
        beamModelText2.topAnchor.constraint(equalTo: eulerBernoulliBeamModelImage.bottomAnchor, constant: 8).isActive = true
        beamModelText2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        beamModelText2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        beamModelText2.font = UIFont.systemFont(ofSize: 14)
        beamModelText2.isScrollEnabled = false
        beamModelText2.isEditable = false
        beamModelText2.dataDetectorTypes = UIDataDetectorTypes.all
        beamModelText2.text = """
        The beam constitutive relations of the Timoshenko beam model can be expressed using the following six equations.
        """
        beamModelText2.textAlignment = .justified
        beamModelText2.backgroundColor = .whiteThemeColor
        beamModelText2.textColor = .blackThemeColor
        
        timoshenkoBeamModelImage.translatesAutoresizingMaskIntoConstraints = false
        timoshenkoBeamModelImage.topAnchor.constraint(equalTo: beamModelText2.bottomAnchor, constant: 8).isActive = true
        timoshenkoBeamModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        timoshenkoBeamModelImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timoshenkoBeamModelImage.contentMode = .scaleAspectFit
        timoshenkoBeamModelImage.clipsToBounds = true
        timoshenkoBeamModelImage.image = #imageLiteral(resourceName: "theory_timoshenko_beam_model")
        
        
        // plate model
        
        let plateModelTitle: UITextView = UITextView()
        let plateModelText1: UITextView = UITextView()
        let kirchhoffLovePlateModelImage: UIImageView = UIImageView()
        let plateModelText2: UITextView = UITextView()
        let reissnerMindlinPlateModelImage: UIImageView = UIImageView()
        
        scrollView.addSubview(plateModelTitle)
        scrollView.addSubview(plateModelText1)
        scrollView.addSubview(kirchhoffLovePlateModelImage)
        scrollView.addSubview(plateModelText2)
        scrollView.addSubview(reissnerMindlinPlateModelImage)
        
        plateModelTitle.translatesAutoresizingMaskIntoConstraints = false
        plateModelTitle.topAnchor.constraint(equalTo: timoshenkoBeamModelImage.bottomAnchor, constant: 24).isActive = true
        plateModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        plateModelTitle.text = "Plate Model"
        plateModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        plateModelTitle.isScrollEnabled = false
        plateModelTitle.isEditable = false
        plateModelTitle.backgroundColor = .whiteThemeColor
        plateModelTitle.textColor = .blackThemeColor
        
        plateModelText1.translatesAutoresizingMaskIntoConstraints = false
        plateModelText1.topAnchor.constraint(equalTo: plateModelTitle.bottomAnchor, constant: 6).isActive = true
        plateModelText1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        plateModelText1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        plateModelText1.font = UIFont.systemFont(ofSize: 14)
        plateModelText1.isScrollEnabled = false
        plateModelText1.isEditable = false
        plateModelText1.dataDetectorTypes = UIDataDetectorTypes.all
        plateModelText1.text = """
        For a structural is modeled as a plate, we need to use plate constitutive relations.
        The plate constitutive relations of the Kirchhoff-Love model can be expressed using the following six equations and the 6 by 6 matrix is commonly called the plate stiffness matrix (A, B, D matrices).
        """
        plateModelText1.textAlignment = .justified
        plateModelText1.backgroundColor = .whiteThemeColor
        plateModelText1.textColor = .blackThemeColor
        
        kirchhoffLovePlateModelImage.translatesAutoresizingMaskIntoConstraints = false
        kirchhoffLovePlateModelImage.topAnchor.constraint(equalTo: plateModelText1.bottomAnchor, constant: 8).isActive = true
        kirchhoffLovePlateModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        kirchhoffLovePlateModelImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        kirchhoffLovePlateModelImage.contentMode = .scaleAspectFit
        kirchhoffLovePlateModelImage.clipsToBounds = true
        kirchhoffLovePlateModelImage.image = #imageLiteral(resourceName: "theory_kirchhoffLove_plate_model")
        
        plateModelText2.translatesAutoresizingMaskIntoConstraints = false
        plateModelText2.topAnchor.constraint(equalTo: kirchhoffLovePlateModelImage.bottomAnchor, constant: 8).isActive = true
        plateModelText2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        plateModelText2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        plateModelText2.font = UIFont.systemFont(ofSize: 14)
        plateModelText2.isScrollEnabled = false
        plateModelText2.isEditable = false
        plateModelText2.dataDetectorTypes = UIDataDetectorTypes.all
        plateModelText2.text = """
        The plate constitutive relations of the Reissner-Mindlin model can be expressed using the following eight equations. The C matrix is the transverse shear stiffness matrix.
        """
        plateModelText2.textAlignment = .justified
        plateModelText2.backgroundColor = .whiteThemeColor
        plateModelText2.textColor = .blackThemeColor
        
        reissnerMindlinPlateModelImage.translatesAutoresizingMaskIntoConstraints = false
        reissnerMindlinPlateModelImage.topAnchor.constraint(equalTo: plateModelText2.bottomAnchor, constant: 8).isActive = true
        reissnerMindlinPlateModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        reissnerMindlinPlateModelImage.heightAnchor.constraint(equalToConstant: 105).isActive = true
        reissnerMindlinPlateModelImage.contentMode = .scaleAspectFit
        reissnerMindlinPlateModelImage.clipsToBounds = true
        reissnerMindlinPlateModelImage.image = #imageLiteral(resourceName: "theory_reissnerMindlin_plate_model")
        
        
        // solid model
        
        let solidModelTitle: UITextView = UITextView()
        let solidModelText1: UITextView = UITextView()
        let cauchyPlateModelImage: UIImageView = UIImageView()
        
        scrollView.addSubview(solidModelTitle)
        scrollView.addSubview(solidModelText1)
        scrollView.addSubview(cauchyPlateModelImage)
        
        solidModelTitle.translatesAutoresizingMaskIntoConstraints = false
        solidModelTitle.topAnchor.constraint(equalTo: reissnerMindlinPlateModelImage.bottomAnchor, constant: 24).isActive = true
        solidModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        solidModelTitle.text = "Solid Model"
        solidModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        solidModelTitle.isScrollEnabled = false
        solidModelTitle.isEditable = false
        solidModelTitle.backgroundColor = .whiteThemeColor
        solidModelTitle.textColor = .blackThemeColor
        
        solidModelText1.translatesAutoresizingMaskIntoConstraints = false
        solidModelText1.topAnchor.constraint(equalTo: solidModelTitle.bottomAnchor, constant: 6).isActive = true
        solidModelText1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        solidModelText1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        solidModelText1.font = UIFont.systemFont(ofSize: 14)
        solidModelText1.isScrollEnabled = false
        solidModelText1.isEditable = false
        solidModelText1.dataDetectorTypes = UIDataDetectorTypes.all
        solidModelText1.text = """
        For a structural is modeled as a solid, we need to use solid constitutive relations.
        The solid constitutive relations of the Cauchy continuum model for the linear elastic behavior are described using the generalized Hooke's law as.
        """
        solidModelText1.textAlignment = .justified
        solidModelText1.backgroundColor = .whiteThemeColor
        solidModelText1.textColor = .blackThemeColor
        
        cauchyPlateModelImage.translatesAutoresizingMaskIntoConstraints = false
        cauchyPlateModelImage.topAnchor.constraint(equalTo: solidModelText1.bottomAnchor, constant: 8).isActive = true
        cauchyPlateModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        cauchyPlateModelImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        cauchyPlateModelImage.contentMode = .scaleAspectFit
        cauchyPlateModelImage.clipsToBounds = true
        cauchyPlateModelImage.image = #imageLiteral(resourceName: "theory_cauchy_solid_model")
        
        
        // structure gene
        
        let structureGeneTitle: UITextView = UITextView()
        let structureGeneText1: UITextView = UITextView()
        let structureGeneImage1: UIImageView = UIImageView()
        let structureGeneText2: UITextView = UITextView()
        let structureGeneImage2: UIImageView = UIImageView()
        let structureGeneText3: UITextView = UITextView()
        let structureGeneImage3: UIImageView = UIImageView()
        
        scrollView.addSubview(structureGeneTitle)
        scrollView.addSubview(structureGeneText1)
        scrollView.addSubview(structureGeneImage1)
        scrollView.addSubview(structureGeneText2)
        scrollView.addSubview(structureGeneImage2)
        scrollView.addSubview(structureGeneText3)
        scrollView.addSubview(structureGeneImage3)
        
        structureGeneTitle.translatesAutoresizingMaskIntoConstraints = false
        structureGeneTitle.topAnchor.constraint(equalTo: cauchyPlateModelImage.bottomAnchor, constant: 24).isActive = true
        structureGeneTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structureGeneTitle.text = "Structure Gene"
        structureGeneTitle.font = UIFont.boldSystemFont(ofSize: 15)
        structureGeneTitle.isScrollEnabled = false
        structureGeneTitle.isEditable = false
        structureGeneTitle.backgroundColor = .whiteThemeColor
        structureGeneTitle.textColor = .blackThemeColor
        
        structureGeneText1.translatesAutoresizingMaskIntoConstraints = false
        structureGeneText1.topAnchor.constraint(equalTo: structureGeneTitle.bottomAnchor, constant: 6).isActive = true
        structureGeneText1.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structureGeneText1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        structureGeneText1.font = UIFont.systemFont(ofSize: 14)
        structureGeneText1.isScrollEnabled = false
        structureGeneText1.isEditable = false
        structureGeneText1.dataDetectorTypes = UIDataDetectorTypes.all
        structureGeneText1.text = """
        In SwiftComp, we introduce a new concenpt structure gene (SG) defined as the smallest mathematical building block of a structure.
        
        The analysis of beam-like heterogeneous composite structures can be approximated by a beam constitutive modeling over a SG by SwiftComp and a corresponding 1D macroscopic beam structural analysis.
        """
        structureGeneText1.textAlignment = .justified
        structureGeneText1.backgroundColor = .whiteThemeColor
        structureGeneText1.textColor = .blackThemeColor
        
        structureGeneImage1.translatesAutoresizingMaskIntoConstraints = false
        structureGeneImage1.topAnchor.constraint(equalTo: structureGeneText1.bottomAnchor, constant: 8).isActive = true
        structureGeneImage1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        structureGeneImage1.heightAnchor.constraint(equalToConstant: 150).isActive = true
        structureGeneImage1.contentMode = .scaleAspectFit
        structureGeneImage1.clipsToBounds = true
        structureGeneImage1.image = #imageLiteral(resourceName: "theory_beam_modeling")
        
        structureGeneText2.translatesAutoresizingMaskIntoConstraints = false
        structureGeneText2.topAnchor.constraint(equalTo: structureGeneImage1.bottomAnchor, constant: 6).isActive = true
        structureGeneText2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structureGeneText2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        structureGeneText2.font = UIFont.systemFont(ofSize: 14)
        structureGeneText2.isScrollEnabled = false
        structureGeneText2.isEditable = false
        structureGeneText2.dataDetectorTypes = UIDataDetectorTypes.all
        structureGeneText2.text = """
        The analysis of plate-like heterogeneous composite structures can be approximated by a plate constitutive modeling over a SG by SwiftComp and a corresponding 2D macroscopic plate structural analysis.
        """
        structureGeneText2.textAlignment = .justified
        structureGeneText2.backgroundColor = .whiteThemeColor
        structureGeneText2.textColor = .blackThemeColor
        
        structureGeneImage2.translatesAutoresizingMaskIntoConstraints = false
        structureGeneImage2.topAnchor.constraint(equalTo: structureGeneText2.bottomAnchor, constant: 8).isActive = true
        structureGeneImage2.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        structureGeneImage2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        structureGeneImage2.contentMode = .scaleAspectFit
        structureGeneImage2.clipsToBounds = true
        structureGeneImage2.image = #imageLiteral(resourceName: "theory_plate_modeling")
        
        structureGeneText3.translatesAutoresizingMaskIntoConstraints = false
        structureGeneText3.topAnchor.constraint(equalTo: structureGeneImage2.bottomAnchor, constant: 6).isActive = true
        structureGeneText3.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        structureGeneText3.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        structureGeneText3.font = UIFont.systemFont(ofSize: 14)
        structureGeneText3.isScrollEnabled = false
        structureGeneText3.isEditable = false
        structureGeneText3.dataDetectorTypes = UIDataDetectorTypes.all
        structureGeneText3.text = """
        The analyses of 3D heterogeneous composite structures can be approximated by a solid constitutive modeling over a a SG by SwiftComp and a corresponding 3D macroscopic solid structural analysis.
        """
        structureGeneText3.textAlignment = .justified
        structureGeneText3.backgroundColor = .whiteThemeColor
        structureGeneText3.textColor = .blackThemeColor
        
        structureGeneImage3.translatesAutoresizingMaskIntoConstraints = false
        structureGeneImage3.topAnchor.constraint(equalTo: structureGeneText3.bottomAnchor, constant: 8).isActive = true
        structureGeneImage3.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        structureGeneImage3.heightAnchor.constraint(equalToConstant: 150).isActive = true
        structureGeneImage3.contentMode = .scaleAspectFit
        structureGeneImage3.clipsToBounds = true
        structureGeneImage3.image = #imageLiteral(resourceName: "theory_solid_modeling")
        
        
        structureGeneImage3.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        
    }
    


}
