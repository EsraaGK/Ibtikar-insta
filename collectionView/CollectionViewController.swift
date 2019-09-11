//
//  CollectionViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/31/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController  {
    var collectionModel = CollectionModel()
    var NavActorObj = Actor ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate=self
         collectionView.dataSource=self
        collectionModel.getResponse(id: NavActorObj.id! , completionHandler: {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
       
    }
   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionModel.profiles.count
    }
    //-------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CartFooterCollectionReusableView", for: indexPath)
            // Customize footerView here
            return footerView
        } else if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myheader", for: indexPath)
            // Customize headerView here
            
            collectionModel.loadHeaderImage(stringURL:NavActorObj.profile_path!, completion:{ data in
                if let myData = data{
                    DispatchQueue.main.async() {
                        ( headerView.viewWithTag(1) as! UIImageView).image  = UIImage(data: myData)
                    }
                    
                }else{
                    ( headerView.viewWithTag(1) as! UIImageView).image = UIImage(named:"Reverb")
                }
                
            })
//            if NavActorObj.profile_path! != "noPath" {
//                if let url = URL(string: NavActorObj.profile_path! ){
//                    let request = URLRequest(url: url)
//                    let task = URLSession.shared.dataTask(with: request) { adata, response, error in
//                        guard let data = adata, error == nil else { return }
//
//                        DispatchQueue.main.async() {
//                            print("this is data \(data)")
//
//                            ( headerView.viewWithTag(1) as! UIImageView).image  = UIImage(data: data)
//                        }
//                    }
//                    task.resume()
//
//                }
//            }else{
//                ( headerView.viewWithTag(1) as! UIImageView).image = UIImage(named:"Reverb")
//            }
          
            (headerView.viewWithTag(2) as! UILabel).text = NavActorObj.name
            (headerView.viewWithTag(3) as! UILabel).text = ("the popularity rate is \(NavActorObj.popularity)")
            return headerView
        }
        fatalError()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        
        // Configure the cell
        collectionModel.loadCollectionImage(index: indexPath.row, completion:{ data in
            if let myData = data{
                DispatchQueue.main.async() {
                    
                    ( cell.viewWithTag(1) as! UIImageView).image  = UIImage(data: myData)
                }
                
            }else{
                 ( cell.viewWithTag(1) as! UIImageView).image = UIImage(named:"Reverb")
            }
            
        })
        return cell
    }
    
  override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let downloadview = self.storyboard?.instantiateViewController(withIdentifier: "mydownloadview") as! DownloadImgVC
        downloadview.StringUrl = collectionModel.profiles[indexPath.row]
        
        self.navigationController?.pushViewController( downloadview, animated: true)
    }

    
    
    

}
