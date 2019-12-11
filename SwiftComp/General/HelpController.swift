//
//  HomeHelp.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 8/22/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HelpController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteThemeColor

        navigationItem.title = "Help"

        editLayout()
    }

    var scrollView: UIScrollView = UIScrollView()

    var brandTitle: UITextView = UITextView()

    var selectModelTitle: UITextView = UITextView()
    var selectModel: UITextView = UITextView()
    var selectModelImage: UIImageView = UIImageView()

    var getSectionHelpTitle: UITextView = UITextView()
    var getSectionHelp: UITextView = UITextView()
    var getSectionHelpImage: UIImageView = UIImageView()

    var runModelTitle: UITextView = UITextView()
    var runModel: UITextView = UITextView()
    var runModelImage: UIImageView = UIImageView()
    var runModel2: UITextView = UITextView()

    var shareResultTitle: UITextView = UITextView()
    var shareResult: UITextView = UITextView()
    var shareResultImage: UIImageView = UIImageView()

    func editLayout() {
        view.addSubview(scrollView)

        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

        scrollView.addSubview(brandTitle)
        scrollView.addSubview(selectModelTitle)
        scrollView.addSubview(selectModel)
        scrollView.addSubview(selectModelImage)
        scrollView.addSubview(getSectionHelpTitle)
        scrollView.addSubview(getSectionHelp)
        scrollView.addSubview(getSectionHelpImage)
        scrollView.addSubview(runModelTitle)
        scrollView.addSubview(runModel)
        scrollView.addSubview(runModelImage)
        scrollView.addSubview(runModel2)
        scrollView.addSubview(shareResultTitle)
        scrollView.addSubview(shareResult)
        scrollView.addSubview(shareResultImage)

        brandTitle.translatesAutoresizingMaskIntoConstraints = false
        brandTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        brandTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        brandTitle.text = "Help"
        brandTitle.font = UIFont.boldSystemFont(ofSize: 20)
        brandTitle.isScrollEnabled = false
        brandTitle.isEditable = false

        selectModelTitle.translatesAutoresizingMaskIntoConstraints = false
        selectModelTitle.topAnchor.constraint(equalTo: brandTitle.bottomAnchor, constant: 24).isActive = true
        selectModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        selectModelTitle.text = "Select an existing model"
        selectModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        selectModelTitle.isScrollEnabled = false
        selectModelTitle.isEditable = false

        selectModel.translatesAutoresizingMaskIntoConstraints = false
        selectModel.topAnchor.constraint(equalTo: selectModelTitle.bottomAnchor, constant: 6).isActive = true
        selectModel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        selectModel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        selectModel.text = """
        There is a list of avaiable models to select when you lanuch the App. For example, you can select "Laminate" or "Unidirectional Fiber Reinforced Composite". Tap a model to enter the analysis settings.
        """
        selectModel.isScrollEnabled = false
        selectModel.isEditable = false
        selectModel.font = UIFont.systemFont(ofSize: 14)
        selectModel.textAlignment = .justified

        selectModelImage.translatesAutoresizingMaskIntoConstraints = false
        selectModelImage.topAnchor.constraint(equalTo: selectModel.bottomAnchor, constant: 8).isActive = true
        selectModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        selectModelImage.heightAnchor.constraint(equalToConstant: 128).isActive = true
        selectModelImage.contentMode = .scaleAspectFit
        selectModelImage.clipsToBounds = true
        selectModelImage.image = #imageLiteral(resourceName: "help_select_model")

        getSectionHelpTitle.translatesAutoresizingMaskIntoConstraints = false
        getSectionHelpTitle.topAnchor.constraint(equalTo: selectModelImage.bottomAnchor, constant: 24).isActive = true
        getSectionHelpTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        getSectionHelpTitle.text = "Analysis settings"
        getSectionHelpTitle.font = UIFont.boldSystemFont(ofSize: 15)
        getSectionHelpTitle.isScrollEnabled = false
        getSectionHelpTitle.isEditable = false

        getSectionHelp.translatesAutoresizingMaskIntoConstraints = false
        getSectionHelp.topAnchor.constraint(equalTo: getSectionHelpTitle.bottomAnchor, constant: 6).isActive = true
        getSectionHelp.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        getSectionHelp.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        getSectionHelp.text = """
        For each model, there are some analysis settings to set. The analysis settings are grouped into sections. For example, the figure below shows "Method" section. You can tap the button at the middle of each section to change settings. You can also tap the question mark at the top right corner for help.
        """
        getSectionHelp.isScrollEnabled = false
        getSectionHelp.isEditable = false
        getSectionHelp.font = UIFont.systemFont(ofSize: 14)
        getSectionHelp.textAlignment = .justified

        getSectionHelpImage.translatesAutoresizingMaskIntoConstraints = false
        getSectionHelpImage.topAnchor.constraint(equalTo: getSectionHelp.bottomAnchor, constant: 8).isActive = true
        getSectionHelpImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        getSectionHelpImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        getSectionHelpImage.contentMode = .scaleAspectFit
        getSectionHelpImage.clipsToBounds = true
        getSectionHelpImage.image = #imageLiteral(resourceName: "help_section_help")

        runModelTitle.translatesAutoresizingMaskIntoConstraints = false
        runModelTitle.topAnchor.constraint(equalTo: getSectionHelpImage.bottomAnchor, constant: 24).isActive = true
        runModelTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        runModelTitle.text = "Run Model"
        runModelTitle.font = UIFont.boldSystemFont(ofSize: 15)
        runModelTitle.isScrollEnabled = false
        runModelTitle.isEditable = false

        runModel.translatesAutoresizingMaskIntoConstraints = false
        runModel.topAnchor.constraint(equalTo: runModelTitle.bottomAnchor, constant: 6).isActive = true
        runModel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        runModel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        runModel.text = """
        To run a model, just tap the "Calculate" button at the bottom toolbar as shown in the figure below.
        """
        runModel.isScrollEnabled = false
        runModel.isEditable = false
        runModel.font = UIFont.systemFont(ofSize: 14)
        runModel.textAlignment = .justified

        runModelImage.translatesAutoresizingMaskIntoConstraints = false
        runModelImage.topAnchor.constraint(equalTo: runModel.bottomAnchor, constant: 8).isActive = true
        runModelImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        runModelImage.heightAnchor.constraint(equalToConstant: 52).isActive = true
        runModelImage.contentMode = .scaleAspectFit
        runModelImage.clipsToBounds = true
        runModelImage.image = #imageLiteral(resourceName: "help_calculate")

        runModel2.translatesAutoresizingMaskIntoConstraints = false
        runModel2.topAnchor.constraint(equalTo: runModelImage.bottomAnchor, constant: 8).isActive = true
        runModel2.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        runModel2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        runModel2.text = """
        Note, to use SwiftComp, internect connection is needed. If you are offline, the color of calculation button will become grey and calculation is not available.
        """
        runModel2.isScrollEnabled = false
        runModel2.isEditable = false
        runModel2.font = UIFont.systemFont(ofSize: 14)
        runModel2.textAlignment = .justified

        shareResultTitle.translatesAutoresizingMaskIntoConstraints = false
        shareResultTitle.topAnchor.constraint(equalTo: runModel2.bottomAnchor, constant: 24).isActive = true
        shareResultTitle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        shareResultTitle.text = "Share Result"
        shareResultTitle.font = UIFont.boldSystemFont(ofSize: 15)
        shareResultTitle.isScrollEnabled = false
        shareResultTitle.isEditable = false

        shareResult.translatesAutoresizingMaskIntoConstraints = false
        shareResult.topAnchor.constraint(equalTo: shareResultTitle.bottomAnchor, constant: 6).isActive = true
        shareResult.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        shareResult.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        shareResult.text = """
        After getting the result, you can share the results. Just tap the "Share" button at the top right corner of the navigation bar as shown in the figure below.
        """
        shareResult.isScrollEnabled = false
        shareResult.isEditable = false
        shareResult.font = UIFont.systemFont(ofSize: 14)
        shareResult.textAlignment = .justified

        shareResultImage.translatesAutoresizingMaskIntoConstraints = false
        shareResultImage.topAnchor.constraint(equalTo: shareResult.bottomAnchor, constant: 8).isActive = true
        shareResultImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        shareResultImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        shareResultImage.contentMode = .scaleAspectFit
        shareResultImage.clipsToBounds = true
        shareResultImage.image = #imageLiteral(resourceName: "help_result_share")

        shareResultImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
    }
}
