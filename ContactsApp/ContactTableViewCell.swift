//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Томирис Рахымжан on 31/03/2024.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier: String = "ContactTableViewCell"


    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = nil
        label.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        label.text = nil
    }
}
