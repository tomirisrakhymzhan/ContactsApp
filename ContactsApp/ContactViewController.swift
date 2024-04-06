//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 31/03/2024.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController,  MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate  {
    

    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        makePhoneCall(number: phoneNumberText)
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        sendEmail(to: emailText)
    }
    
    @IBOutlet weak var AALabel: UILabel!
    @IBOutlet weak var phoneNumberBtn: UIButton!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    @IBOutlet weak var emailBtn: UIButton!
    
    
    var nameLabelText = ""
    var surnameLabelText = ""
    var phoneNumberText = ""
    var emailText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameSurnameLabel.text = "\(nameLabelText) \(surnameLabelText)"
        AALabel.text = "\(String(describing: nameLabelText[nameLabelText.startIndex]))\(String(describing: surnameLabelText[surnameLabelText.startIndex]))"
        phoneNumberBtn.setTitle(phoneNumberText, for: .normal)
        emailBtn.setTitle(emailText, for: .normal)
    }

    @IBAction func smsButtonPressed(_ sender: Any) {
        // call send sms method
        sendSMS()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("SMS cancelled")
        case .sent:
            print("SMS sent")
        case .failed:
            print("SMS failed")
        @unknown default:
            print("Unknown result")
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendSMS() {
        if MFMessageComposeViewController.canSendText() {
            let messageController = MFMessageComposeViewController()
            messageController.body = "Your message here"
            messageController.recipients = ["Recipient's phone number"]
            messageController.messageComposeDelegate = self
            present(messageController, animated: true, completion: nil)
        } else {
            // Handle the case where the device can't send SMS
            print("SMS services are not available")
        }
    }
    
    
    @IBAction func callButtonPressed(_ sender: Any) {
        makePhoneCall(number: phoneNumberText)
    }
    
    func makePhoneCall(number: String) {
        // Check if the device can make phone calls
        guard let phoneURL = URL(string: "tel://\(number)") else {
            print("Invalid phone number")
            return
        }

        // Check if the device can open the phone URL
        if UIApplication.shared.canOpenURL(phoneURL) {
            // Open the phone URL
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Unable to make phone call")
        }
    }
    
    @IBAction func videocallButtonPressed(_ sender: Any) {
        makeFaceTimeCall(emailOrPhoneNumber: phoneNumberText)
    }
    
    func makeFaceTimeCall(emailOrPhoneNumber: String) {
        // Check if the device supports FaceTime
        guard let facetimeURL = URL(string: "facetime://\(emailOrPhoneNumber)") else {
            print("Invalid FaceTime address")
            return
        }

        // Check if the device can open the FaceTime URL
        if UIApplication.shared.canOpenURL(facetimeURL) {
            // Open the FaceTime URL
            UIApplication.shared.open(facetimeURL, options: [:], completionHandler: nil)
        } else {
            print("Unable to initiate FaceTime call")
        }
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        sendEmail(to: emailText)
    }
    
func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Email composition cancelled")
        case .sent:
            print("Email sent successfully")
        case .failed:
            print("Email sending failed: \(error?.localizedDescription ?? "Unknown error")")
        case .saved:
            print("Email draft saved")
        @unknown default:
            print("Unknown result")
        }

        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail(to: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }

        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setToRecipients([to]) // Set email recipient(s)
        mailController.setSubject("Subject of the email") // Set email subject
        mailController.setMessageBody("Body of the email", isHTML: false) // Set email body

        present(mailController, animated: true, completion: nil)
    }
}
