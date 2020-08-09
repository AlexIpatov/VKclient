//
//  PhotoFriendsCollectionViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit




class PhotoFriendsCollectionViewController: UICollectionViewController {
    let itemsPerRow: CGFloat = 2
    let sectionsInserds = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
       
    }
    
    var photoInPhotoCollection: [String] = []
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoInPhotoCollection.count
        
    }
    
    
 
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendsCell", for: indexPath) as? PhotoFriendsCell else {fatalError()}
        let imageName = photoInPhotoCollection[indexPath.item]
        cell.photoFriends.image = UIImage(named: imageName)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AnimatedFriendsPhotoViewController") as? AnimatedPhotoViewController  else { return}
        vc.photoCollection = photoInPhotoCollection
        vc.currentIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    
        
     }

}

extension PhotoFriendsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let paddingWidth = sectionsInserds.left * (itemsPerRow + 1)
        let avalibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avalibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInserds
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserds.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserds.left
    }
    
}

