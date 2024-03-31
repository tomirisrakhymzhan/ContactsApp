//
//  ViewController.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 30/03/2024.
//

import UIKit

class ViewController: UIViewController {

    var contacts = ["Paul Atreides", "Daenerys Stormborn Targaryen", "Tomiris the Queen"]
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getContacts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    @objc func getContacts(){
        //retrieve from userdefaults contacts
    }


}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        cell.label.text = contacts[indexPath.row]
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil) 
        contactVC.nameSurnameLabelText = contacts[indexPath.row]
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
}

struct Contact: Codable{
    var name: String
    var surname: String
    var phoneNumber: String
}
