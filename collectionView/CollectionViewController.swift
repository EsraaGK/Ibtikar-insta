//
//  CollectionViewController.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/31/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, ActorCollectionViewProtocol  {
    
    func refreshActorView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //var collectionModel : ActorCollectionModelProtocol
    
    var presenter: ActorPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate=self
        collectionView.dataSource=self
        presenter!.getResponse(completionHandler: {
            self.refreshActorView()
        })
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return presenter!.getArrayCount()
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
            let fullpath = "https://image.tmdb.org/t/p/w500"+presenter!.getActorProfilePath()

            ( headerView.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: fullpath), placeholderImage: UIImage(named: "Reverb"))
            
            
            (headerView.viewWithTag(2) as! UILabel).text = presenter!.getActorNameAt()
            (headerView.viewWithTag(3) as! UILabel).text = ("the popularity rate is \(presenter!.getActorPopularityAt())")
            return headerView
        }
        fatalError()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath)
        
        // Configure the cell
        
        let fullpath = "https://image.tmdb.org/t/p/w500" + presenter!.getObjectForCell(index: indexPath.row)
        ( cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string:fullpath), placeholderImage: UIImage(named: "Reverb"))
     
        return cell
    }
    
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let downloadview = self.storyboard?.instantiateViewController(withIdentifier: "mydownloadview") as! DownloadImgVC
        let stringUrl = presenter!.getObjectForCell(index: indexPath.row)
        downloadview.downloadPresenter = DownloadPresenter(viewObj: downloadview, modelObj:DownloadImgModel(urlString: stringUrl))
        //
        
        self.navigationController?.pushViewController( downloadview, animated: true)
    }
    
    
    
    
    
}
