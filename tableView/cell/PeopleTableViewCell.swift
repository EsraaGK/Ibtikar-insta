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
        
        peopleImageView.sd_setImage(with: URL(string:actorOBJ.profile_path!), placeholderImage: UIImage(named: "Reverb"))
//        peopleTableViewCellModel.loadImg(stringUrl: actorOBJ.profile_path!, completionHandler: {
//            myData in
//            if let data = myData{
//                DispatchQueue.main.async {
//
//                    self.peopleImageView.image = UIImage(data: data)
//
//                }
//            }else{
//                self.peopleImageView.image = UIImage(named:"Reverb")
//            }//else
//        })//completion
      
    }
    
}
