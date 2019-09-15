//
//  PeopleViewController.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/12/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate{

    
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    let tableModel = TableModel()
    var peopleURL="https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US"
    var searchURL="https://api.themoviedb.org/3/search/person?api_key=1a45f741aada87874aacfbeb73119bae&query="
    
    var ApiPageNo = 1
    var totalPagesNo = 0
    var currentUrl = ""
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        ApiPageNo = 1
        self.tableModel.removeAllandReload(){
            
            peopleTableView.reloadData()
            
            tableModel.getJson(pnumber: 1, urlString: currentUrl){
                DispatchQueue.main.async {
                    print("hi")
                    self.peopleTableView.reloadData()
                    
                }
            }
            
        }
        peopleTableView.refreshControl!.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "PeopleTableViewCell", bundle: Bundle.main)
        peopleTableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
        
        peopleTableView.delegate=self
        peopleTableView.dataSource=self
        
        searchTextField.delegate=self
        //    session = URLSession.shared
        
        
        tableModel.getJson(pnumber: ApiPageNo,urlString: peopleURL){
            self.ApiPageNo = self.tableModel.ApiPageNo
            self.totalPagesNo = self.tableModel.totalPagesNo
            DispatchQueue.main.async {
                
                self.peopleTableView.reloadData()
            }
            
        }
        currentUrl = peopleURL
        
        
        peopleTableView.refreshControl = UIRefreshControl()
        peopleTableView.refreshControl?.tintColor = UIColor(red:0.16, green:0.68, blue:0.9, alpha:1)
        peopleTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        peopleTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        //         let collectionview = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
        if tableModel.results.count != 0{
            let collectionview = self.storyboard?.instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
            collectionview.NavActorObj = tableModel.results[indexPath.row]
            
            self.navigationController?.pushViewController( collectionview, animated: true)
        }
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
                
                self.peopleTableView.reloadData()
            }
            
        }
        
        
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ApiPageNo=1
        self.tableModel.search()
        peopleTableView.reloadData()
        if let query = searchTextField.text{
            if query == ""{currentUrl = peopleURL}else{
                currentUrl = searchURL+query
                print(currentUrl)
                print("the url \(currentUrl)")
            }
            
        }else{
            currentUrl = peopleURL
        }
        
        tableModel.getJson(pnumber:1, urlString: currentUrl.replacingOccurrences(of: " ", with:"%20")){
            DispatchQueue.main.async {
                
                self.peopleTableView.reloadData()
            }
        }
        return true
    }
   
}


extension PeopleViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as? PeopleTableViewCell{
            //load more
            
            if indexPath.row == self.tableModel.results.count-7 && self.ApiPageNo <= self.totalPagesNo {
                self.ApiPageNo += 1
                tableModel.getJson(pnumber: ApiPageNo, urlString: currentUrl){
                    DispatchQueue.main.async {
                        self.peopleTableView.reloadData()
                    }
                }
            }
            
        //configure cell
        cell.configure( actorOBJ: tableModel.results[indexPath.row])
        
        return cell
        }else{
            print("can't find cell")
            return UITableViewCell()
        }
    }
    
    
}
