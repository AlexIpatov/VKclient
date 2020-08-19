//
//  PhotoFriendsCollectionViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import Kingfisher



class PhotoFriendsCollectionViewController: UICollectionViewController {
    var photos = [Photo]()
    var userID = -1
    let itemsPerRow: CGFloat = 2
    let sectionsInserds = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.loadPhotos(token: Session.shared.token, userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case let .failure(error):
                print(error)
            }
        }
        
        collectionView.dataSource = self
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
        
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendsCell", for: indexPath) as? PhotoFriendsCell else {fatalError()}
        let imageName = photos[indexPath.item]
        let urlImg = imageName.url
        print("testingURL",urlImg)
        cell.photoFriends.kf.setImage(with: URL(string: urlImg))
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AnimatedFriendsPhotoViewController") as? AnimatedPhotoViewController  else { return}
        
        vc.photoCollection = photos
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

