//
//  AboutTableViewController.swift
//  SwiftComp
//
//  Created by Banghua Zhao on 10/1/19.
//  Copyright © 2019 Banghua Zhao. All rights reserved.
//

import UIKit
import MessageUI

class GeneralViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let generalModels = GeneralModels()
    let rowHeight : CGFloat = 30 + 8 + 8
    let sectionMarketingHeight : CGFloat = 160
    let sectionHeight : CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(GeneralModelCell.self, forCellReuseIdentifier: "CellID")
        tableView.backgroundColor = .greybackgroundColor

        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         
         super.viewWillAppear(true)
         
         self.tabBarController?.title = "General"
         
     }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return generalModels.infoModels.count
        } else if section == 1 {
            return generalModels.helpModels.count
        } else if section == 2 {
            return generalModels.feedbackModel.count
        } else if section == 3 {
            return generalModels.rateModel.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionMarketingHeight
        } else {
            return sectionHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let marketingView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionMarketingHeight))
            let swiftcompLogo = UIImageView(image: UIImage(imageLiteralResourceName: "swiftcomp_logo_long"))
            marketingView.addSubview(swiftcompLogo)
            swiftcompLogo.translatesAutoresizingMaskIntoConstraints = false
            swiftcompLogo.centerXAnchor.constraint(equalTo: marketingView.centerXAnchor).isActive = true
            swiftcompLogo.centerYAnchor.constraint(equalTo: marketingView.centerYAnchor).isActive = true
            swiftcompLogo.widthAnchor.constraint(equalToConstant: 280).isActive = true
            swiftcompLogo.heightAnchor.constraint(equalToConstant: 80).isActive = true
            swiftcompLogo.contentMode = .scaleAspectFit
            
            return marketingView
        } else {
            let dividerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeight))
            return dividerView
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! GeneralModelCell
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0 {
            cell.generalModel = generalModels.infoModels[indexPath.row]
        } else if indexPath.section == 1 {
            cell.generalModel = generalModels.helpModels[indexPath.row]
        } else if indexPath.section == 2 {
            cell.generalModel = generalModels.feedbackModel[indexPath.row]
            cell.accessoryType = .none
        } else if indexPath.section == 3 {
            cell.generalModel = generalModels.rateModel[indexPath.row]
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(AboutViewController(), animated: true)
            } else {
                self.navigationController?.pushViewController(HelpViewController(), animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(TheoryViewController(), animated: true)
            } else {
                self.navigationController?.pushViewController(UserManualViewController(), animated: true)
            }
           
        case 2:
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            let mailComposeViewController = configureMailController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                showMailError()
            }
        case 3:
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            guard let url = URL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            break
        }
        
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["zhao563@purdue.edu"])
        mailComposerVC.setSubject("Feedback for SwiftComp iOS App")
        mailComposerVC.setMessageBody("""
        Dear SwiftComp iOS App Team:
            Your feedbacks...
        """, isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email. Please send an email to zhao563@purdue.edu from another device to let us know your feedback. Thanks!", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil || result == .failed {
            controller.dismiss(animated: true, completion: {
                let sendMailErrorAlert = UIAlertController(title: "Error while sending email", message: "Could not send email due to error. Please send an email to zhao563@purdue.edu by another method to let us know your feedback. Thanks!", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
                sendMailErrorAlert.addAction(dismiss)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            })
        }
        
        if result == .sent {
            controller.dismiss(animated: true, completion:{
                let sendMailSucceedAlert = UIAlertController(title: "Feedback is sent", message: "Your feedback is sent to us. We will reply to you as soon as possible. Thanks for your feedback!", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
                sendMailSucceedAlert.addAction(dismiss)
                self.present(sendMailSucceedAlert, animated: true, completion: nil)
            })
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
                
    }
    
    
    
}
