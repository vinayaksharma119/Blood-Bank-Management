//
//  CampsTableViewCell.swift
//  Blood Bank
//
//  Created by Vinayak Sharma on 17/04/20.
//  Copyright © 2020 Vinayak Sharma. All rights reserved.
//

import UIKit

class CampsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
