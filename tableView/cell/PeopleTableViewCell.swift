//
//  PeopleTableViewCell.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/12/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet private weak var peopleImageView: UIImageView!
    
    @IBOutlet weak var ActorNameLable: UILabel!
    
    private var peopleTableViewCellModel = PeopleTableViewCellModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(actorOBJ :Actor){
        print(actorOBJ.name!+"mmmmmmmm")
        ActorNameLable.text = actorOBJ.name! //as! String
        
        
        peopleTableViewCellModel.loadImg(stringUrl: actorOBJ.profile_path!, completionHandler: {
            myData in
            if let data = myData{
                DispatchQueue.main.async {
                  //  if let updateCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                       // let img:UIImage! = UIImage(data: data)
                    //    updateCell.cellImg.image = img
                    self.peopleImageView.image = UIImage(data: data)
                 //   }
                }
            }else{
                self.peopleImageView.image = UIImage(named:"Reverb")
            }//else
        })//completion
      
    }
    
}
