//
//  TableViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITextFieldDelegate  {
    var results : [Actor] = Array()
    let tableModel = TableModel()
    
    @IBOutlet weak var searchTextField: UITextField!
    var peopleURL="https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US"
    
    var searchURL="https://api.themoviedb.org/3/search/person?api_key=1a45f741aada87874aacfbeb73119bae&query="
    
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject , AnyObject>!
    var ApiPageNo = 1
    var totalPagesNo = 0
    var currentUrl = ""
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        ApiPageNo = 1
        getResponse(pnumber: ApiPageNo,urlString: currentUrl)
        self.refreshControl!.endRefreshing()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate=self
        //    session = URLSession.shared
        task = URLSessionDownloadTask()
        
        getResponse(pnumber: ApiPageNo,urlString: peopleURL)
        currentUrl = peopleURL
        self.cache = NSCache()
        
        self.tableView.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor(red:0.16, green:0.68, blue:0.9, alpha:1)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    func getResponse (pnumber :Int,urlString:String){
      
        // this is made for the pull-to-reload
        
        if pnumber == 1 {
           
            results.removeAll()
            self.tableView.reloadData()
            
        }
        
        let urlApi = urlString + "&page=\(pnumber)"
        if let url = URL(string:urlApi ) {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let  dataResponse = data{
                    DispatchQueue.main.async {
                        
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse , options:[]) as! NSDictionary
                            
                            self.totalPagesNo = jsonResponse.value(forKey: "total_pages") as! Int
                            self.ApiPageNo = jsonResponse.value(forKey: "page") as! Int
                            let x = jsonResponse.value(forKey: "results") as! NSArray
                            
                            for n in x {
                                let tmp = Actor ()
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
        
        if indexPath.row == results.count-6 && self.ApiPageNo <= self.totalPagesNo {
            
            self.ApiPageNo += 1
            
            getResponse(pnumber: ApiPageNo, urlString: currentUrl)
        }
        
        
        if results[indexPath.row].profile_path! != "noPath"  {
            
            cell.cellImg.image = UIImage(named: "Reverb")
            
            if (self.cache.object(forKey: (self.results[indexPath.row].profile_path! as AnyObject)) != nil){
                // 2
                // Use cache
                print("Cached image used, no need to download it")
                cell.cellImg.image = self.cache.object(forKey: (self.results[indexPath.row].profile_path!) as AnyObject) as? UIImage
            }else{
                // 3
                
                let url:URL! = URL(string: results[indexPath.row].profile_path!)
                task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        // 4
                        DispatchQueue.main.async(execute: { () -> Void in
                            // 5
                            // Before we assign the image, check whether the current cell is visible
                            if let updateCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.cellImg.image = img
                                self.cache.setObject( img, forKey: self.results[indexPath.row].profile_path! as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }
            
            
        }else{
            cell.cellImg.image = UIImage(named:"Reverb")
        }
        
        cell.nameLable.text = results[indexPath.row].name! //as! String

        return cell
    }
    
    
    
    
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let collectionview = self.storyboard?.instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
        collectionview.NavActorObj = results[indexPath.row]
        
        self.navigationController?.pushViewController( collectionview, animated: true)
        //
    }
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchTextField.text=""
        self.results.removeAll()
        //searchFlag = false
        currentUrl=peopleURL
        ApiPageNo = 1
        getResponse(pnumber: ApiPageNo,urlString: currentUrl)
      
        
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.results.removeAll()
        currentUrl = searchURL+searchTextField.text!
    
        ApiPageNo=1
       getResponse(pnumber:ApiPageNo, urlString: searchURL+searchTextField.text!)
        return true
    }
    
}
