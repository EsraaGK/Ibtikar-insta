//
//  TableViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITextFieldDelegate  {
    
    let tableModel = TableModel()
    
    @IBOutlet weak var searchTextField: UITextField!
    var peopleURL="https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US"
    
    var searchURL="https://api.themoviedb.org/3/search/person?api_key=1a45f741aada87874aacfbeb73119bae&query="
    
    
//    var task: URLSessionDownloadTask!
//    var session: URLSession!
//    var cache:NSCache<AnyObject , AnyObject>!
    var ApiPageNo = 1
    var totalPagesNo = 0
    var currentUrl = ""
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        ApiPageNo = 1
        //i had to remove the elements and reload table view to avoid Fatal error: Index out of range
        
        self.tableModel.removeAllandReload(){
            
            self.tableView.reloadData()
            
            tableModel.getJson(pnumber: 1, urlString: currentUrl){
                DispatchQueue.main.async {
                    print("hi")
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        self.refreshControl!.endRefreshing()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate=self
        //    session = URLSession.shared
     
        
        tableModel.getJson(pnumber: ApiPageNo,urlString: peopleURL){
            self.ApiPageNo = self.tableModel.ApiPageNo
            self.totalPagesNo = self.tableModel.totalPagesNo
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
        currentUrl = peopleURL
          
        
        self.tableView.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor(red:0.16, green:0.68, blue:0.9, alpha:1)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.tableModel.results.count
        
    }
    //----------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell
        
      //load more
        
        if indexPath.row == self.tableModel.results.count-7 && self.ApiPageNo <= self.totalPagesNo {
            self.ApiPageNo += 1
            tableModel.getJson(pnumber: ApiPageNo, urlString: currentUrl){
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        
          //         Configure the cell...
        tableModel.loadImg(index: indexPath.row, completionHandler: {
            myData in
            if let data = myData{
                DispatchQueue.main.async {
                    if let updateCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                                                        let img:UIImage! = UIImage(data: data)
                                                        updateCell.cellImg.image = img
                    }
                }
            }else{
                cell.cellImg.image = UIImage(named:"Reverb")
            }
        })
//        
//        if self.tableModel.results[indexPath.row].profile_path! != "noPath"  {
//            
//            cell.cellImg.image = UIImage(named: "Reverb")
//            
//            if (self.cache.object(forKey: (self.tableModel.results[indexPath.row].profile_path! as AnyObject)) != nil){
//                // 2
//                // Use cache
//                print("Cached image used, no need to download it")
//                cell.cellImg.image = self.cache.object(forKey: (self.tableModel.results[indexPath.row].profile_path!) as AnyObject) as? UIImage
//            }else{
//                // 3
//                
//                let url:URL! = URL(string: self.tableModel.results[indexPath.row].profile_path!)
//                task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
//                    if let data = try? Data(contentsOf: url){
//                        // 4
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            // 5
//                            // Before we assign the image, check whether the current cell is visible
//                            if let updateCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
//                                let img:UIImage! = UIImage(data: data)
//                                updateCell.cellImg.image = img
//                                self.cache.setObject( img, forKey: self.tableModel.results[indexPath.row].profile_path! as AnyObject)
//                            }
//                        })
//                    }
//                })
//                task.resume()
//            }
//            
//            
//        }else{
//            cell.cellImg.image = UIImage(named:"Reverb")
//        }
        
        cell.nameLable.text = self.tableModel.results[indexPath.row].name! //as! String
        
        return cell
    }
    
    
    
    
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let collectionview = self.storyboard?.instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
        collectionview.NavActorObj = self.tableModel.results[indexPath.row]
        
        self.navigationController?.pushViewController( collectionview, animated: true)
        //
    }
    
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchTextField.text=""
        self.tableModel.results.removeAll()
        
        currentUrl=peopleURL
        ApiPageNo = 1
        tableModel.getJson(pnumber: ApiPageNo,urlString: currentUrl){
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
        
        
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.tableModel.search()
        currentUrl = searchURL+searchTextField.text!
        ApiPageNo=1
        tableModel.getJson(pnumber:ApiPageNo, urlString: searchURL+searchTextField.text!.replacingOccurrences(of: " ", with:"%20")){
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        return true
    }
    
}
