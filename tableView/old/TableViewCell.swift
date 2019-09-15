//
//  TableViewCell.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var popularityLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
