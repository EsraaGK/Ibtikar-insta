//
//  PeopleTableViewCell.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/12/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit
import SDWebImage

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet private weak var peopleImageView: UIImageView!
    
    @IBOutlet weak var ActorNameLable: UILabel!
    
    private var peopleTableViewCellModel = PeopleTableViewCellModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessibilityIdentifier = "TableViewCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(actorOBJ :Actor){
       // print(actorOBJ.name!)
        ActorNameLable.text = actorOBJ.name! //as! String
        guard let path=actorOBJ.profile_path else {return}
        var fullpath = "https://image.tmdb.org/t/p/w500"+path
        peopleImageView.sd_setImage(with: URL(string:fullpath), placeholderImage: UIImage(named: "Reverb"))
        print(fullpath)
    }
    
}
