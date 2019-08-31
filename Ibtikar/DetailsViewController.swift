//
//  ViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//


import UIKit

class DetailsViewController: UIViewController {
    var NavigationActorObj : Actor!
    var x = 2
    @IBOutlet weak var Info: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ActorImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("iinside\(x)")
        print( NavigationActorObj.profile_path!)
        // Do any additional setup after loading the view, typically from a nib.
        if let s = NavigationActorObj.profile_path {

            if let url = URL(string: s){
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async() {

                        self.ActorImg.image = UIImage(data: data)

                }
            }
            task.resume()

            }else{
                //  if NavigationActorObj.profile_path == "noPath"
               ActorImg.image = UIImage(named:"Reverb")
            }

        }else{

            ActorImg.image = UIImage(named:"Reverb")
            Name.text = NavigationActorObj.name!
            print(NavigationActorObj.name!)
           Info.text = "His popularity is \(NavigationActorObj.popularity)"
            print(NavigationActorObj.popularity!)
        }

   }


}

