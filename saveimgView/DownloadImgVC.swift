//
//  DownloadImgVC.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/31/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit
import SDWebImage

class DownloadImgVC: UIViewController, DownloadViewProtocol {
   
    var downloadPresenter :DownloadPresenter?
    
    @IBOutlet weak var ImgtoDownload: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         let fullpath = "https://image.tmdb.org/t/p/w500" + downloadPresenter!.getActorImgPath()
        
        ImgtoDownload.sd_setImage(with: URL(string:fullpath), placeholderImage: UIImage(named: "placeholder.png"))

    }
    
    @IBAction func downloadImg(_ sender: Any) {
        
        downloadPresenter!.downloadActorImg(completion: {
            myData in
            if let data = myData,
                let image = UIImage(data: data) {
                    
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                } 
        })
        
        }
            
    

    
}
