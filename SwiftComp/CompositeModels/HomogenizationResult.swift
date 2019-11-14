//
//  HomogenizationResult
//  SwiftComp
//
//  Created by Banghua Zhao on 08/26/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit

class HomogenizationResult: UIViewController {
    var analysisSettings = AnalysisSettings(compositeModelName: .Laminate, calculationMethod: .SwiftComp, typeOfAnalysis: .elastic, structuralModel: .solid, structuralSubmodel: .CauchyContinuumModel)

    var resultData = ResultData()

    var resultLabel = ResultCardLabel()
    var swiftCompHomogenizationCalculationInfoController = SwiftCompCalculationInfo()

    // layout

    var scrollView: UIScrollView = UIScrollView()

    // result view

    var resultView: UIView = UIView()
    var resultViewShareButton: UIButton = UIButton()

    // effective beam stiffness matrix 4 by 4

    var effectiveBeamStiffnessMatrix4by4Card: UIView = UIView()

    var effectiveBeamStiffnessMatrix4by4TitleLabel: UILabel = UILabel()

    var effectiveBeamStiffnessMatrix4by4ResultLabel: [UILabel] = []

    // effective beam stiffness matrix 6 by 6

    var effectiveBeamStiffnessMatrix6by6Card: UIView = UIView()

    var effectiveBeamStiffnessMatrix6by6TitleLabel: UILabel = UILabel()

    var effectiveBeamStiffnessMatrix6by6ResultLabel: [UILabel] = []

    // A Matrix

    var AMatrixCard: UIView = UIView()

    var AMatrixTitleLabel: UILabel = UILabel()

    var AMatrixResultLabel: [UILabel] = []

    // B Matrix

    var BMatrixCard: UIView = UIView()

    var BMatrixTitleLabel: UILabel = UILabel()

    var BMatrixResultLabel: [UILabel] = []

    // D Matrix

    var DMatrixCard: UIView = UIView()

    var DMatrixTitleLabel: UILabel = UILabel()

    var DMatrixResultLabel: [UILabel] = []

    // C Matrix

    var CMatrixCard: UIView = UIView()

    var CMatrixTitleLabel: UILabel = UILabel()

    var CMatrixResultLabel: [UILabel] = []

    // in plane properties

    var inPlanePropertiesCard: UIView = UIView()

    var inPlanePropertiesTitleLabel: UILabel = UILabel()

    var inPlanePropertiesLabel: [UILabel] = []

    var inPlanePropertiesResultLabel: [UILabel] = []

    // flexural properties

    var flexuralPropertiesCard: UIView = UIView()

    var flexuralPropertiesTitleLabel: UILabel = UILabel()

    var flexuralPropertiesLabel: [UILabel] = []

    var flexuralPropertiesResultLabel: [UILabel] = []

    // flexural properties

    var thermalCoefficientsCard: UIView = UIView()

    var thermalCoefficientsTitleLabel: UILabel = UILabel()

    var thermalCoefficientsLabel: [UILabel] = []

    var thermalCoefficientsResultLabel: [UILabel] = []

    // effective solid stiffness matrix

    var effectiveSolidStiffnessMatrixCard: UIView = UIView()

    var effectiveSolidStiffnessMatrixTitleLabel: UILabel = UILabel()

    var effectiveSolidStiffnessMatrixResultLabel: [UILabel] = []

    // engineering constants

    var engineeringConstantsCard: UIView = UIView()

    var engineeringConstantsTitleLabel: UILabel = UILabel()

    var engineeringConstantsLabel: [UILabel] = []

    var engineeringConstantsResultLabel: [UILabel] = []

    // gmsh mesh image

    var gmshMeshImageCard: UIView = UIView()

    var gmshMeshImageCardShareButton: UIButton = UIButton()

    var gmshMeshImageView = UIImageView()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    // SwiftComp Output

    var swiftCompCalculationInfoCard: UIView = UIView()

    var swiftCompCalculationInfoButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .greybackgroundColor

        createLayout()

        applyResult()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        editNavigationBar()
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            if analysisSettings.calculationMethod == .SwiftComp {
                // delete user's swiftcomp working directory

                var API_URL = "\(baseURL)"

                if analysisSettings.compositeModelName == .Laminate {
                    API_URL += "/Laminate/delete?userDirectory=\(resultData.swiftcompCwd)"
                } else if analysisSettings.compositeModelName == .UDFRC {
                    API_URL += "/UDFRC/delete?userDirectory=\(resultData.swiftcompCwd)"
                }

                guard let urlString = API_URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

                guard let url = URL(string: urlString) else { return }

                URLSession.shared.dataTask(with: url) { _, _, err in

                    if let err = err {
                        print(err)
                        return
                    }

                    // successful

                    print("successful deleted \(self.resultData.swiftcompCwd)")

                }.resume()
            }
        }
    }

    deinit {
        print("Homogenization result viewcontroller is deinitialized.")
    }

    // MARK: Create layout

    func createLayout() {
        view.addSubview(scrollView)

        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

        scrollView.addSubview(resultView)

        resultView.addSubview(resultViewShareButton)

        resultViewShareButton.shareButtonDesign(under: resultView)
        resultViewShareButton.addTarget(self, action: #selector(shareResult), for: .touchUpInside)

        if analysisSettings.structuralModel == .beam {
            createViewCard(viewCard: resultView, title: "Beam Model Result", aboveConstraint: scrollView.topAnchor, under: scrollView)

            if analysisSettings.structuralSubmodel == .EulerBernoulliBeamModel {
                resultView.addSubview(effectiveBeamStiffnessMatrix4by4Card)
                effectiveBeamStiffnessMatrix4by4TitleLabel.text = "Effective Beam Stiffness Matrix"
                createResult4by4MatrixCard(resultCard: effectiveBeamStiffnessMatrix4by4Card, title: effectiveBeamStiffnessMatrix4by4TitleLabel, result: &effectiveBeamStiffnessMatrix4by4ResultLabel, aboveConstraint: resultView.topAnchor, under: resultView, firstCard: true)

                effectiveBeamStiffnessMatrix4by4Card.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true

            } else if analysisSettings.structuralSubmodel == .TimoshenkoBeamModel {
                resultView.addSubview(effectiveBeamStiffnessMatrix6by6Card)
                effectiveBeamStiffnessMatrix6by6TitleLabel.text = "Effective Refined Beam Stiffness Matrix"
                createResult6by6MatrixCard(resultCard: effectiveBeamStiffnessMatrix6by6Card, title: effectiveBeamStiffnessMatrix6by6TitleLabel, result: &effectiveBeamStiffnessMatrix6by6ResultLabel, aboveConstraint: resultView.topAnchor, under: resultView)

                effectiveBeamStiffnessMatrix6by6Card.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true
            }

        } else if analysisSettings.structuralModel == .plate {
            createViewCard(viewCard: resultView, title: "Plate Model Result", aboveConstraint: scrollView.topAnchor, under: scrollView)
            resultView.addSubview(AMatrixCard)
            resultView.addSubview(BMatrixCard)
            resultView.addSubview(DMatrixCard)
            resultView.addSubview(inPlanePropertiesCard)
            resultView.addSubview(flexuralPropertiesCard)

            AMatrixTitleLabel.text = "A Matrix"
            createResult3by3MatrixCard(resultCard: AMatrixCard, title: AMatrixTitleLabel, result: &AMatrixResultLabel, aboveConstraint: resultView.topAnchor, under: resultView, firstCard: true)

            BMatrixTitleLabel.text = "B Matrix"
            createResult3by3MatrixCard(resultCard: BMatrixCard, title: BMatrixTitleLabel, result: &BMatrixResultLabel, aboveConstraint: AMatrixCard.bottomAnchor, under: resultView, firstCard: false)

            DMatrixTitleLabel.text = "D Matrix"
            createResult3by3MatrixCard(resultCard: DMatrixCard, title: DMatrixTitleLabel, result: &DMatrixResultLabel, aboveConstraint: BMatrixCard.bottomAnchor, under: resultView, firstCard: false)

            if analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                resultView.addSubview(CMatrixCard)

                CMatrixTitleLabel.text = "Transverse Shear Stiffness Matrix"
                createGeneralTwoByTwoStiffnessMatrix(resultCard: CMatrixCard, title: CMatrixTitleLabel, result: &CMatrixResultLabel, aboveConstraint: DMatrixCard.bottomAnchor, under: resultView)

                // In-plane Properties

                inPlanePropertiesTitleLabel.text = "In-plane Properties"

                creatResultListCard(resultCard: inPlanePropertiesCard, title: inPlanePropertiesTitleLabel, label: &inPlanePropertiesLabel, result: &inPlanePropertiesResultLabel, aboveConstraint: CMatrixCard.bottomAnchor, under: resultView, resultType: .inPlateProperties)

            } else {
                // In-plane Properties

                inPlanePropertiesTitleLabel.text = "In-plane Properties"

                creatResultListCard(resultCard: inPlanePropertiesCard, title: inPlanePropertiesTitleLabel, label: &inPlanePropertiesLabel, result: &inPlanePropertiesResultLabel, aboveConstraint: DMatrixCard.bottomAnchor, under: resultView, resultType: .inPlateProperties)
            }

            // Flexural Properties

            flexuralPropertiesTitleLabel.text = "Flexural Properties"

            creatResultListCard(resultCard: flexuralPropertiesCard, title: flexuralPropertiesTitleLabel, label: &flexuralPropertiesLabel, result: &flexuralPropertiesResultLabel, aboveConstraint: inPlanePropertiesCard.bottomAnchor, under: resultView, resultType: .inPlateProperties)

            if analysisSettings.typeOfAnalysis == .elastic {
                flexuralPropertiesCard.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true

            } else if analysisSettings.typeOfAnalysis == .thermoElastic {
                // Thermal Coefficients

                scrollView.addSubview(thermalCoefficientsCard)

                thermalCoefficientsTitleLabel.text = "Thermal Coefficients"

                creatResultListCard(resultCard: thermalCoefficientsCard, title: thermalCoefficientsTitleLabel, label: &thermalCoefficientsLabel, result: &thermalCoefficientsResultLabel, aboveConstraint: flexuralPropertiesCard.bottomAnchor, under: scrollView, resultType: .thermalCoefficients)

                thermalCoefficientsCard.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true
            }

        } else if analysisSettings.structuralModel == .solid {
            createViewCard(viewCard: resultView, title: "Solid Model Result", aboveConstraint: scrollView.topAnchor, under: scrollView)

            resultView.addSubview(effectiveSolidStiffnessMatrixCard)
            resultView.addSubview(engineeringConstantsCard)

            // effective solid stiffness matrix

            effectiveSolidStiffnessMatrixTitleLabel.text = "Effective Solid Stiffness Matrix"

            createResult6by6MatrixCard(resultCard: effectiveSolidStiffnessMatrixCard, title: effectiveSolidStiffnessMatrixTitleLabel, result: &effectiveSolidStiffnessMatrixResultLabel, aboveConstraint: resultView.topAnchor, under: resultView)

            // Engineering Constants

            engineeringConstantsTitleLabel.text = "Engineering Constants"

            creatResultListCard(resultCard: engineeringConstantsCard, title: engineeringConstantsTitleLabel, label: &engineeringConstantsLabel, result: &engineeringConstantsResultLabel, aboveConstraint: effectiveSolidStiffnessMatrixCard.bottomAnchor, under: resultView, resultType: .engineeringConstantsOrthotropic)

            if analysisSettings.typeOfAnalysis == .elastic {
                engineeringConstantsCard.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true

            } else if analysisSettings.typeOfAnalysis == .thermoElastic {
                // Thermal Coefficients

                resultView.addSubview(thermalCoefficientsCard)

                thermalCoefficientsTitleLabel.text = "Thermal Coefficients"

                creatResultListCard(resultCard: thermalCoefficientsCard, title: thermalCoefficientsTitleLabel, label: &thermalCoefficientsLabel, result: &thermalCoefficientsResultLabel, aboveConstraint: engineeringConstantsCard.bottomAnchor, under: resultView, resultType: .thermalCoefficients)

                thermalCoefficientsCard.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -12).isActive = true
            }
        }

        if analysisSettings.calculationMethod == .SwiftComp {
            if analysisSettings.compositeModelName != .Laminate {
                scrollView.addSubview(gmshMeshImageCard)

                createViewCard(viewCard: gmshMeshImageCard, title: "Mesh Image", aboveConstraint: resultView.bottomAnchor, under: scrollView)

                gmshMeshImageCard.addSubview(gmshMeshImageCardShareButton)

                gmshMeshImageCardShareButton.shareButtonDesign(under: gmshMeshImageCard)
                gmshMeshImageCardShareButton.addTarget(self, action: #selector(shareMeshImage), for: .touchUpInside)

                gmshMeshImageCard.addSubview(gmshMeshImageView)
                
                gmshMeshImageView.snp.makeConstraints { (make) in
                    make.size.equalTo(310)
                    make.top.equalToSuperview().offset(36)
                    make.bottom.equalToSuperview().offset(-12)
                    make.centerX.equalToSuperview()
                }
                gmshMeshImageView.backgroundColor = .imageGreyColor

                gmshMeshImageView.isUserInteractionEnabled = true
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
                longPressRecognizer.minimumPressDuration = 0.5
                gmshMeshImageView.addGestureRecognizer(longPressRecognizer)

                gmshMeshImageView.addSubview(activityIndicator)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.centerXAnchor.constraint(equalTo: gmshMeshImageView.centerXAnchor).isActive = true
                activityIndicator.centerYAnchor.constraint(equalTo: gmshMeshImageView.centerYAnchor).isActive = true
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = .gray
                activityIndicator.startAnimating()

                fetchGmshMeshImage()
            }

            scrollView.addSubview(swiftCompCalculationInfoCard)

            if analysisSettings.compositeModelName != .Laminate {
                createViewCard(viewCard: swiftCompCalculationInfoCard, title: "SwiftComp Calculation Info", aboveConstraint: gmshMeshImageCard.bottomAnchor, under: scrollView)
            } else {
                createViewCard(viewCard: swiftCompCalculationInfoCard, title: "SwiftComp Calculation Info", aboveConstraint: resultView.bottomAnchor, under: scrollView)
            }

            swiftCompCalculationInfoCard.addSubview(swiftCompCalculationInfoButton)

            swiftCompCalculationInfoButton.swiftCompOutputButtonDesign(under: swiftCompCalculationInfoCard)
            swiftCompCalculationInfoButton.addTarget(self, action: #selector(showSwiftCompOutput), for: .touchUpInside)

            swiftCompCalculationInfoButton.bottomAnchor.constraint(equalTo: swiftCompCalculationInfoCard.bottomAnchor, constant: -12).isActive = true

            swiftCompCalculationInfoCard.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true

        } else {
            resultView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        }
    }

    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        guard let meshImageGuard = gmshMeshImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(meshImageGuard, self, #selector(imageNew(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func imageNew(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The mesh image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    // MARK: Apply results

    func applyResult() {
        if analysisSettings.structuralModel == .beam {
            if analysisSettings.structuralSubmodel == .EulerBernoulliBeamModel {
                let max = resultData.effectiveBeamStiffness4by4.max() ?? 0
                fillResultsRoundSmall(resultItems: resultData.effectiveBeamStiffness4by4, resultLabel: effectiveBeamStiffnessMatrix4by4ResultLabel, max: max)
            } else if analysisSettings.structuralSubmodel == .TimoshenkoBeamModel {
                let max = resultData.effectiveBeamStiffness6by6.max() ?? 0
                fillResultsRoundSmall(resultItems: resultData.effectiveBeamStiffness6by6, resultLabel: effectiveBeamStiffnessMatrix6by6ResultLabel, max: max)
            }

        } else if analysisSettings.structuralModel == .plate {
            let maxA = resultData.AMatrix.max() ?? 0
            let maxB = resultData.BMatrix.max() ?? 0
            let maxD = resultData.DMatrix.max() ?? 0
            let max = [maxA, maxB, maxD].max() ?? 0

            fillResultsRoundSmall(resultItems: resultData.AMatrix, resultLabel: AMatrixResultLabel, max: max)

            fillResultsRoundSmall(resultItems: resultData.BMatrix, resultLabel: BMatrixResultLabel, max: max)

            fillResultsRoundSmall(resultItems: resultData.DMatrix, resultLabel: DMatrixResultLabel, max: max)

            if analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                let maxC = resultData.CMatrix.max() ?? 0
                let maxNew = [maxA, maxB, maxD, maxC].max() ?? 0
                fillResultsRoundSmall(resultItems: resultData.CMatrix, resultLabel: CMatrixResultLabel, max: maxNew)
            }

            fillResults(resultItems: resultData.effectiveInplaneProperties, resultLabel: inPlanePropertiesResultLabel)

            fillResults(resultItems: resultData.effectiveFlexuralProperties, resultLabel: flexuralPropertiesResultLabel)

        } else if analysisSettings.structuralModel == .solid {
            let max = resultData.effectiveSolidStiffnessMatrix.max() ?? 0

            fillResultsRoundSmall(resultItems: resultData.effectiveSolidStiffnessMatrix, resultLabel: effectiveSolidStiffnessMatrixResultLabel, max: max)

            fillResults(resultItems: resultData.engineeringConstantsOrthotropic, resultLabel: engineeringConstantsResultLabel)
        }

        if analysisSettings.typeOfAnalysis == .thermoElastic {
            fillResults(resultItems: resultData.effectiveThermalCoefficients, resultLabel: thermalCoefficientsResultLabel)
        }
    }

    // fetch gmsh image

    func fetchGmshMeshImage() {
        var route = ""
        switch analysisSettings.compositeModelName {
        case .UDFRC:
            route = "UDFRC"
        case .HoneycombSandwich:
            route = "honeycombSandwich"
        default:
            break
        }

        let urlStringRaw = "\(baseURL)/\(route)/meshImage?userDirectory=\(resultData.swiftcompCwd)"

        guard let urlString = urlStringRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, err in

            if let err = err {
                print("Failed to fetch mesh image from server: \(err)")
            }

            // successful
            guard let data = data else { return }

            DispatchQueue.main.async {
                self.gmshMeshImageView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }

    // swiftcomp output

    @objc func showSwiftCompOutput(_ sender: UIButton) {
        swiftCompHomogenizationCalculationInfoController = SwiftCompCalculationInfo()

        swiftCompHomogenizationCalculationInfoController.swiftCompCalculationInfoValue = resultData.swiftcompCalculationInfo

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.navigationController?.pushViewController(self.swiftCompHomogenizationCalculationInfoController, animated: true)
        }
    }

    // MARK: Edit navigation bar

    func editNavigationBar() {
        navigationItem.title = "Result"

        navigationController?.setToolbarHidden(true, animated: false)
    }

    @objc func shareResult(_ sender: UIButton) {
        var str: String = ""

        if analysisSettings.structuralModel == .beam {
            if analysisSettings.structuralSubmodel == .EulerBernoulliBeamModel {
                str += "Effetive Beam Stiffness Matrix:\n"
                for i in 0 ... 3 {
                    str += effectiveBeamStiffnessMatrix4by4ResultLabel[i * 4].text! + "\t" + effectiveBeamStiffnessMatrix4by4ResultLabel[i * 4 + 1].text! + "\t" + effectiveBeamStiffnessMatrix4by4ResultLabel[i * 4 + 2].text! + "\t" + effectiveBeamStiffnessMatrix4by4ResultLabel[i * 4 + 3].text! + "\n"
                }
            } else if analysisSettings.structuralSubmodel == .TimoshenkoBeamModel {
                str += "Effetive Refined Beam Stiffness Matrix:\n"
                for i in 0 ... 5 {
                    str += effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6].text! + "\t" + effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6 + 1].text! + "\t" + effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6 + 2].text! + "\t" + effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6 + 3].text! + "\t" + effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6 + 4].text! + "\t" + effectiveBeamStiffnessMatrix6by6ResultLabel[i * 6 + 5].text! + "\n"
                }
            }

        } else if analysisSettings.structuralModel == .plate {
            str += "A Matrix:\n"

            for i in 0 ... 2 {
                str += AMatrixResultLabel[i * 3].text! + "\t" + AMatrixResultLabel[i * 3 + 1].text! + "\t" + AMatrixResultLabel[i * 3 + 2].text! + "\n"
            }

            str += "\n"

            str += "B Matrix:\n"

            for i in 0 ... 2 {
                str += BMatrixResultLabel[i * 3].text! + "\t" + BMatrixResultLabel[i * 3 + 1].text! + "\t" + BMatrixResultLabel[i * 3 + 2].text! + "\n"
            }

            str += "\n"

            str += "D Matrix:\n"

            for i in 0 ... 2 {
                str += DMatrixResultLabel[i * 3].text! + "\t" + DMatrixResultLabel[i * 3 + 1].text! + "\t" + DMatrixResultLabel[i * 3 + 2].text! + "\n"
            }

            if analysisSettings.structuralSubmodel == .ReissnerMindlinPlateShellModel {
                str += "\n"

                str += "Transverse Shear Stiffness Matrix:\n"

                for i in 0 ... 1 {
                    str += CMatrixResultLabel[i * 2].text! + "\t" + CMatrixResultLabel[i * 2 + 1].text! + "\n"
                }
            }

            str += "\n"

            str += "In-plane Properties:\n"

            for i in 0 ... 5 {
                str += resultLabel.inPlatePropertiesLabel[i] + ": \t" + inPlanePropertiesResultLabel[i].text! + "\n"
            }

            str += "\n"

            str += "Flexural Properties:\n"

            for i in 0 ... 5 {
                str += resultLabel.inPlatePropertiesLabel[i] + ": \t" + flexuralPropertiesResultLabel[i].text! + "\n"
            }

        } else if analysisSettings.structuralModel == .solid {
            str += "Effective Solid Stiffness Matrix:\n"

            for i in 0 ... 5 {
                str += effectiveSolidStiffnessMatrixResultLabel[i * 6].text! + "\t" + effectiveSolidStiffnessMatrixResultLabel[i * 6 + 1].text! + "\t" + effectiveSolidStiffnessMatrixResultLabel[i * 6 + 2].text! + "\t" + effectiveSolidStiffnessMatrixResultLabel[i * 6 + 3].text! + "\t" + effectiveSolidStiffnessMatrixResultLabel[i * 6 + 4].text! + "\t" + effectiveSolidStiffnessMatrixResultLabel[i * 6 + 5].text! + "\n"
            }

            str += "\n"

            str += "Engineering Constants:\n"

            for i in 0 ... 8 {
                str += resultLabel.engineeringConstantsOrthotropicLabel[i] + ": \t" + engineeringConstantsLabel[i].text! + "\n"
            }
        }

        if analysisSettings.typeOfAnalysis == .thermoElastic {
            str += "\n"

            str += "Thermal Coefficients:\n"

            for i in 0 ... 5 {
                str += resultLabel.thermalCoefficientsLabel[i] + ": \t" + thermalCoefficientsResultLabel[i].text! + "\n"
            }
        }

        let file = getDocumentsDirectory().appendingPathComponent("Result.txt")

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        present(activityVC, animated: true, completion: nil)
    }

    @objc func shareMeshImage(_ sender: UIButton) {
        // image to share
        guard let meshImageGuard = gmshMeshImageView.image else { return }

        // set up activity view controller
        let imageToShare = [meshImageGuard]
        let activityVC = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        // present the view controller
        present(activityVC, animated: true, completion: nil)
    }
}
