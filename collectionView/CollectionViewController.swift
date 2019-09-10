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
    var profiles = Array<String>()
    var NavActorObj = Actor ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate=self
         collectionView.dataSource=self
        getResponse()
       
    }
    // MARK: - Table view data source

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return profiles.count
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
            
            
            if NavActorObj.profile_path! != "noPath" {
                if let url = URL(string: NavActorObj.profile_path! ){
                    let request = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: request) { adata, response, error in
                        guard let data = adata, error == nil else { return }
                        
                        DispatchQueue.main.async() {
                            print("this is data \(data)")
                            
                            ( headerView.viewWithTag(1) as! UIImageView).image  = UIImage(data: data)
                            //UIImage(named: "Reverb")
                            //
                            
                        }
                    }
                    task.resume()
                    
                }
            }else{
                ( headerView.viewWithTag(1) as! UIImageView).image = UIImage(named:"Reverb")
            }
          
            (headerView.viewWithTag(2) as! UILabel).text = NavActorObj.name
            (headerView.viewWithTag(3) as! UILabel).text = ("the popularity rate is \(NavActorObj.popularity)")
            return headerView
        }
        fatalError()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        
        // Configure the cell
        
         if profiles[indexPath.row] != "noPath" {
        if let url = URL(string: profiles[indexPath.row]){
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { adata, response, error in
                guard let data = adata, error == nil else { return }
                
                DispatchQueue.main.async() {
                    print("this is data \(data)")
                   
                     ( cell.viewWithTag(1) as! UIImageView).image  = UIImage(data: data)
                        //UIImage(named: "Reverb")
                        //
                    
                }
            }
            task.resume()
            
        }
    }else{
     ( cell.viewWithTag(1) as! UIImageView).image = UIImage(named:"Reverb")
    }
       
        return cell
    }
    
  override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let downloadview = self.storyboard?.instantiateViewController(withIdentifier: "mydownloadview") as! DownloadImgVC
        downloadview.StringUrl = profiles[indexPath.row]
        
        self.navigationController?.pushViewController( downloadview, animated: true)
    }

    
    func getResponse (){
        
        // Obtain Reference to Shared Session
        let sharedSession = URLSession.shared
        
        if let url = URL(string: "https://api.themoviedb.org/3/person/\(NavActorObj.id!)/images?api_key=3955a9144c79cb1fca10185c95080107") {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let  dataResponse = data{
                    DispatchQueue.main.async {
                        
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse , options:[]) as! NSDictionary
                            print(jsonResponse)
                            
                            var x = jsonResponse.value(forKey: "profiles") as! NSArray
                            for n in x {
                                var tmp :String
                                
                                if let  e = (n as! NSDictionary ).value(forKey: "file_path") as? String{
                                    tmp = "https://image.tmdb.org/t/p/w500\(e)"
                                    print(tmp)
                                }else{
                                    tmp = "noPath"
                                }
                                self.profiles.append(tmp)
                                
                                //    print(tmp.name! as String)
                                self.collectionView.reloadData()
                                print("the profile img no is\(self.profiles.count)")
                            }
                            // print("\(jsonResponse.value(forKey: "page")!)")
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                        
                    }
                }
            })
            
            dataTask.resume()
        }
        
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
