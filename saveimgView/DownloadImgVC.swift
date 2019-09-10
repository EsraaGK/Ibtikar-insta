//
//  DownloadImgVC.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/31/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class DownloadImgVC: UIViewController {

    var StringUrl : String?
    
    @IBOutlet weak var ImgtoDownload: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if StringUrl! != "noPath" {
            if let url = URL(string: StringUrl!){
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) { adata, response, error in
                    guard let data = adata, error == nil else { return }
                    
                    DispatchQueue.main.async() {
                        print("this is data \(data)")
                        //print("this is response \(response)")
                        self.ImgtoDownload!.image = UIImage(data: data)
                       
                    }
                }
                task.resume()
                
            }
        }else{
            ImgtoDownload!.image = UIImage(named:"Reverb")
        }
    }
    @IBAction func downloadImg(_ sender: Any) {
        
        
        if let url = URL(string: StringUrl!),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {

           UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
 
        }
            
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
