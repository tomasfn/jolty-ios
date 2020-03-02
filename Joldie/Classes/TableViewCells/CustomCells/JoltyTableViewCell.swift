//
//  JoltyTableViewCell.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 6/3/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class JoltyTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var JoltyDateLbl: UILabel!
    @IBOutlet weak var JoltyActionImgView: UIImageView! {
        didSet {

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func getFullNameFromUserId(id: String) {
        Database.database().reference().child("Users").child(id).child("user_details").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                self.guestNameLbl.text = "\(data["name"]!) \(data["last_name"]!)"
            }
        })
    }
}

