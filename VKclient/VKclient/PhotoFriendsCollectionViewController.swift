//
//  PhotoFriendsCollectionViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit




class PhotoFriendsCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
       
    }
        
    var photoInPhotoCollection: [String]!

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
                  return photoInPhotoCollection.count
            
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendsCell", for: indexPath) as? PhotoFriendsCell else {fatalError()}
       
      
        
        let imageName = photoInPhotoCollection[indexPath.item]
        cell.photoFriends.image = UIImage(named: imageName)
        
    
      
        return cell
    }


}
