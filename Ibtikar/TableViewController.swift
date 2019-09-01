//
//  TableViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var results : [Actor] = Array()
    

    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject , AnyObject>!
    var ApiPageNo = 1
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        getResponse(pageNo: 1)
        self.refreshControl!.endRefreshing()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        session = URLSession.shared
        task = URLSessionDownloadTask()
        getResponse(pageNo: ApiPageNo)
        
        self.cache = NSCache()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor(red:0.16, green:0.68, blue:0.9, alpha:1)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
       
    }
   
    func getResponse (pageNo :Int){
        
        // Obtain Reference to Shared Session
        let sharedSession = URLSession.shared
        
        if pageNo == 1 {
            var results : [Actor] = Array()
        }
        
        if let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US&page=\(pageNo)") {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let  dataResponse = data{
                    DispatchQueue.main.async {
                        
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse , options:[]) as! NSDictionary
                            
                            var x = jsonResponse.value(forKey: "results") as! NSArray
                            for n in x {
                                var tmp = Actor ()
                                tmp.adult = (n as! NSDictionary ).value(forKey: "adult") as! Bool
                                tmp.name = (n as! NSDictionary ).value(forKey: "name") as! String
                                tmp.id = (n as! NSDictionary ).value(forKey: "id") as! Int
                                
                                if let  e = (n as! NSDictionary ).value(forKey: "profile_path") as? String{
                                    tmp.profile_path = "https://image.tmdb.org/t/p/w500\(e)"
                                }else{
                                    tmp.profile_path = "noPath"
                                }
                                tmp.popularity = (n as! NSDictionary ).value(forKey: "popularity") as! Double
                                var tmp_known_for = (n as! NSDictionary ).value(forKey: "known_for") as! NSArray
                                
                                for w in tmp_known_for {
                                    var temp_film = Film()
                                    
                                    temp_film.id = (n as! NSDictionary ).value(forKey: "id") as! Int
                                    if let y = (n as! NSDictionary).value(forKey: "poster_path" )  {
                                        temp_film.poster_path = ( "https://image.tmdb.org/t/p/w500\(y)" as! String)
                                    } else {
                                        
                                        temp_film.poster_path = "noPath"
                                    }
                                    
                                    if let y = (n as! NSDictionary).value(forKey: "title" )  {
                                        temp_film.title = y as! String
                                    } else {
                                        
                                        temp_film.title = "no path"
                                    }
                                    
                                    //                                    temp_film.title = (n as! NSDictionary ).value(forKey: "title") as! String
                                    
                                    tmp.known_for?.append(temp_film)
                                }
                                
                                self.results.append(tmp)
                                
                            //    print(tmp.name! as String)
                               self.tableView.reloadData()
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return results.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

//         Configure the cell...
        
        if indexPath.row == (ApiPageNo * 20 - 7)  && self.ApiPageNo < 500 {
            
             self.ApiPageNo += 1
        getResponse(pageNo: ApiPageNo)
            
        }
        
        
        if results[indexPath.row].profile_path! != "noPath" {

            cell.cellImg.image = UIImage(named: "Reverb")

            if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                // 2
                // Use cache
                print("Cached image used, no need to download it")
                cell.cellImg.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                // 3

                let url:URL! = URL(string: results[indexPath.row].profile_path!)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        // 4
                        DispatchQueue.main.async(execute: { () -> Void in
                            // 5
                            // Before we assign the image, check whether the current cell is visible
                            if let updateCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.cellImg.image = img
                                self.cache.setObject( img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }

//            //-------------------------------------
//            if let url = URL(string: results[indexPath.row].profile_path!){
//                            let request = URLRequest(url: url)
//                            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                                guard let data = data, error == nil else { return }
//
//                                DispatchQueue.main.async() {
//
//                                        cell.cellImg.image = UIImage(data: data)
//
//                                }
//                            }
//                            task.resume()
//
//                            }
        }else{
          cell.cellImg.image = UIImage(named:"Reverb")
        }

        cell.nameLable.text = results[indexPath.row].name! //as! String
        print("from cell \(indexPath.row)")
       // cell.popularityLable.text = "gamal"
        return cell
    }

  
    
    
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myviewcontroller") as!ViewController

//    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "myviewcontroller") as!DetailsViewController
//    viewController.NavigationActorObj = results[indexPath.row]
//    viewController.x = 5
//   print(results[indexPath.row].profile_path!)

    let collectionview = self.storyboard?.instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
    collectionview.NavActorObj = results[indexPath.row]
    
      self.navigationController?.pushViewController( collectionview, animated: true)
//
    }
    
    
    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
