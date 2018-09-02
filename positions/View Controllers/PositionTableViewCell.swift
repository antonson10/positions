//
//  PositionTableViewCell.swift
//  positions
//
//  Created by Anton Chugunov on 29.08.2018.
//  Copyright © 2018 Anton Chugunov. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
