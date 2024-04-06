//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 31/03/2024.
//

import UIKit

class ContactViewController: UIViewController {

    @IBAction func phoneNumberPressed(_ sender: UIButton) {
    }
    
    @IBOutlet weak var AALabel: UILabel!
    @IBOutlet weak var phoneNumberBtn: UIButton!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    var nameLabelText = ""
    var surnameLabelText = ""
    var phoneNumberText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameSurnameLabel.text = "\(nameLabelText) \(surnameLabelText)"
        AALabel.text = "\(String(describing: nameLabelText[nameLabelText.startIndex]))\(String(describing: surnameLabelText[surnameLabelText.startIndex]))"
        phoneNumberBtn.setTitle(phoneNumberText, for: .normal)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
