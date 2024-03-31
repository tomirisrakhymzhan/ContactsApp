//
//  ContactViewController.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 31/03/2024.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var nameSurnameLabel: UILabel!
    var nameSurnameLabelText = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameSurnameLabel.text = nameSurnameLabelText
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
