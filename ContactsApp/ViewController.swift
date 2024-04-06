//
//  ViewController.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 30/03/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        updateContacts()
        tableView.reloadData()
    }
    
    var contactsDataSource : [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var firstLetterSection : [Character] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateContacts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContacts()
    }
    @objc func updateContacts(){
        tableView.refreshControl?.endRefreshing()
        contactsDataSource = ViewController.getAllContacts()
        initSectionTitles()
    }

    static func getAllContacts() -> [Contact]{
        var allContacts : [Contact] = []
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: Contact.keyString) as? Data {
            
            do {
                let decoder = JSONDecoder()
                allContacts = try decoder.decode([Contact].self, from: data)
            } catch {
                print("could'n decode given data to [Contact] with error: \(error.localizedDescription)")
            }
        }
        return allContacts
    }
    
    func saveContact(contact: Contact){
        var allContacts = ViewController.getAllContacts()
        allContacts.append(contact)
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(allContacts)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: Contact.keyString)
            tableView.reloadData()
        } catch {
            print("Couldn't encode given [Userscore] into data with error: \(error.localizedDescription)")
        }
    }
    
    func initSectionTitles() {
        // Populate firstLetterSection array with unique first letters from names or surnames
        let allFirstLetters = contactsDataSource.flatMap { [$0.name.first, $0.surname.first] }
        let uniqueFirstLetters = Set(allFirstLetters.compactMap { $0 })
        firstLetterSection = uniqueFirstLetters.sorted()
    }
    @IBAction func addContactPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Contact", message: nil, preferredStyle: .alert)
        var nameTextField: UITextField?
        var surnameTextField: UITextField?
        var phoneNumberTextField: UITextField?
        var emailTextField: UITextField?

        alert.addTextField{ (textField) in
            textField.placeholder = "Name"
            nameTextField = textField
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Surname"
            surnameTextField = textField
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Phone number"
            textField.keyboardType = .phonePad // Set keyboard type to phone pad
            phoneNumberTextField = textField
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "example@mail.com"
            textField.keyboardType = .emailAddress // Set keyboard type to email address
            emailTextField = textField
        }
        let newContactAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            guard let name = nameTextField?.text, !name.isEmpty,
                  let surname = surnameTextField?.text, !surname.isEmpty,
                  let phoneNumber = phoneNumberTextField?.text, !phoneNumber.isEmpty,
                  let email = emailTextField?.text, !email.isEmpty
            else {
                self.showAlert(message: "All fields are required")
                return
            }
            
            guard phoneNumber.isValidPhoneNumber() else {
                self.showAlert(message: "Invalid phone number")
                return
            }
            
            guard email.isValidEmail()else {
                self.showAlert(message: "Invalid email format")
                return
            }
            let contact = Contact(name: name, surname: surname, phoneNumber: phoneNumber, email: email)
            self.saveContact(contact: contact)
        })
        newContactAction.isEnabled = false // Initially disable the OK button
        alert.addAction(newContactAction)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("Add contact cancelled")}))
        
        // Add observer for text change in text fields
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { (notification) in
            newContactAction.isEnabled = !(nameTextField?.text?.isEmpty ?? true) &&
                                      !(surnameTextField?.text?.isEmpty ?? true) &&
                                      !(phoneNumberTextField?.text?.isEmpty ?? true) &&
                                      !(emailTextField?.text?.isEmpty ?? true)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetterSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let firstLetter = firstLetterSection[section]
        let contactsListForSection : [Contact]
        switch segmentControl.selectedSegmentIndex {
        case 0:
            contactsListForSection = contactsDataSource.filter{$0.name.first == firstLetter}
            return contactsListForSection.count
        case 1:
            contactsListForSection = contactsDataSource.filter{$0.surname.first == firstLetter}
            return contactsListForSection.count
        default:
            print("segment control index out of range")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(firstLetterSection[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let firstLetter = firstLetterSection[indexPath.section]
        let contactsListForSection : [Contact]
        let contact : Contact
        switch segmentControl.selectedSegmentIndex{
        case 0:
            //by name
            contactsListForSection = contactsDataSource.filter {$0.name.first == firstLetter}
            contact = contactsListForSection[indexPath.row]
            cell.label.text = contact.name + " " + contact.surname
        case 1:
            //by surname
            contactsListForSection = contactsDataSource.filter {$0.surname.first == firstLetter}
            contact = contactsListForSection[indexPath.row]
            cell.label.text = contact.surname + " " + contact.name
        default:
            print("segment control index out of range")
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
        let firstLetter = firstLetterSection[indexPath.section]
        let contactsListForSection : [Contact]
        let contact : Contact
        switch segmentControl.selectedSegmentIndex{
        case 0:
            //by name
            contactsListForSection = contactsDataSource.filter {$0.name.first == firstLetter}
            contact = contactsListForSection[indexPath.row]
            contactVC.nameLabelText = contact.name
            contactVC.surnameLabelText = contact.surname
            contactVC.phoneNumberText = contact.phoneNumber
            contactVC.emailText =  contact.email ?? "no email"
        case 1:
            //by surname
            contactsListForSection = contactsDataSource.filter {$0.surname.first == firstLetter}
            contact = contactsListForSection[indexPath.row]
            contactVC.nameLabelText = contact.name
            contactVC.surnameLabelText = contact.surname
            contactVC.phoneNumberText = contact.phoneNumber
            contactVC.emailText =  contact.email ?? "no email"
        default:
            print("segment control index out of range")
        }
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
}

struct Contact: Codable{
    static let keyString = "contacts-list"
    var name: String
    var surname: String
    var phoneNumber: String
    var email: String?
}

extension String {
    func isValidPhoneNumber() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        let matches = detector?.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        return matches?.count ?? 0 > 0
    }
    
    func isValidEmail() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        let emails = matches?.filter { $0.url?.scheme == "mailto" }
        return emails?.count ?? 0 > 0
    }
}
