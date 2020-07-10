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
        
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       switch userId {
              case [0, 0]:
                  return alexPhoto.count
             case [0, 1]:
                         return dashaPhoto.count
              case [0, 2]:
                         return aleshaPhoto.count
                  default:
                    return 0
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendsCell", for: indexPath) as? PhotoFriendsCell else {fatalError()}
        if userId == [0, 0] {
               let data = alexPhoto[indexPath.row]
            cell.photoFriends.image = UIImage(named: data)
        } else if userId == [0, 1] {
               let data = dashaPhoto[indexPath.row]
            cell.photoFriends.image = UIImage(named: data)
        } else if userId == [0, 2] {
            let data = aleshaPhoto[indexPath.row]
                       cell.photoFriends.image = UIImage(named: data)
        }
        
        
      
        
    
      
        return cell
    }


}
