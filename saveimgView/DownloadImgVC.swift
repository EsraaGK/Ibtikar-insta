//
//  DownloadImgVC.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/31/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class DownloadImgVC: UIViewController {
    let downloadImgModel = DownloadImgModel()
    var StringUrl : String?
    
    @IBOutlet weak var ImgtoDownload: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downloadImgModel.loadImg(stringURL: StringUrl!, completionHandler: {myData in
            if let data = myData{
                DispatchQueue.main.async() {
                    print("this is data \(data)")
                    //print("this is response \(response)")
                    self.ImgtoDownload!.image = UIImage(data: data)
                }
            }else{
                self.ImgtoDownload!.image = UIImage(named:"Reverb")
        }
      })
    }
    
    @IBAction func downloadImg(_ sender: Any) {
        
        downloadImgModel.downloadImg(StringUrl: StringUrl!, completionHandler:{
            myData in
            if let data = myData,
                let image = UIImage(data: data) {
                    
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                } 
        })
        
        }
            
    

    
}
