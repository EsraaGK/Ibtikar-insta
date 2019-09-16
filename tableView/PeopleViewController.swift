//
//  PeopleViewController.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/12/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, PeopleTableViewProtocol{
    func refreshTableView() {
        DispatchQueue.main.async {
            self.peopleTableView.reloadData()
        }
    }
    
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var presenter: PeoplePresenter?
    var peopleURL="https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US"
    var searchURL="https://api.themoviedb.org/3/search/person?api_key=1a45f741aada87874aacfbeb73119bae&query="
    
    // var ApiPageNo = 1
    //  var totalPagesNo = 0
    var currentUrl = ""
    
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        presenter!.setApiPageNo(pageNo: 1)
        self.presenter!.removeAllandReload(){
            
            presenter!.getObjects(number: 1, urlString: currentUrl){
                refreshTableView()
            }
        }
        peopleTableView.refreshControl!.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PeoplePresenter(ViewObj: self , ModelObj: TableModel())
        
        let nib = UINib(nibName: "PeopleTableViewCell", bundle: Bundle.main)
        peopleTableView.register(nib, forCellReuseIdentifier: "PeopleTableViewCell")
        
        peopleTableView.delegate=self
        peopleTableView.dataSource=self
        searchTextField.delegate=self
        
        
        let apiPageNo = presenter!.getApiPageNo()
        presenter!.getObjects(number: apiPageNo,urlString: peopleURL){
            refreshTableView()
        }
        currentUrl = peopleURL
        
        
        peopleTableView.refreshControl = UIRefreshControl()
        peopleTableView.refreshControl?.tintColor = UIColor(red:0.16, green:0.68, blue:0.9, alpha:1)
        peopleTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        peopleTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let arrayCount = presenter!.getArrayCount()
        if arrayCount != 0{
            let collectionview = self.storyboard?.instantiateViewController(withIdentifier: "mycollectionview") as!CollectionViewController
            let actorObj = presenter!.getObjectForCell(index: indexPath.row)
            collectionview.presenter = ActorPresenter(ViewObj: collectionview, ModelObj: CollectionModel(ActorObj: actorObj))
            self.navigationController?.pushViewController( collectionview, animated: true)
        }
        //
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchTextField.text=""
        self.presenter!.removeAllandReload {
            
            currentUrl=peopleURL
            presenter!.setApiPageNo(pageNo: 1)
            presenter!.getObjects(number: 1,urlString: currentUrl){
                refreshTableView()
            }
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter!.setApiPageNo(pageNo: 1)
        presenter!.removeAllandReload {
            if let query = searchTextField.text{
                if query == ""{currentUrl = peopleURL}else{
                    currentUrl = searchURL+query
                    print(currentUrl)
                    print("the url \(currentUrl)")
                }
                
            }else{
                currentUrl = peopleURL
            }
            
            presenter!.getObjects(number: 1, urlString: currentUrl.replacingOccurrences(of: " ", with:"%20")){
                refreshTableView()
            }
        }
        return true
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //load more
        var pageNo = self.presenter!.getApiPageNo()
        let  totalPageNo = self.presenter!.getTotalPageNo()
        if indexPath.row == presenter!.getArrayCount()-1 && pageNo <= totalPageNo {
            pageNo += 1
            print("total pageno =\(pageNo)")
            presenter!.setApiPageNo(pageNo: pageNo)
            presenter!.getObjects(number: pageNo, urlString: currentUrl){
                refreshTableView()
            }
        }
    }
    
}


extension PeopleViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.getArrayCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as? PeopleTableViewCell{
            //configure cell
            cell.configure( actorOBJ: presenter!.getObjectForCell(index: indexPath.row))
            
            return cell
        }else{
            print("can't find cell")
            return UITableViewCell()
        }
    }
    
    
    
}
