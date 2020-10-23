//
//  PhotoFriendsCollectionViewController.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotoFriendsCollectionViewController: UICollectionViewController {
    
    private var photos: Results<Photo>? {
        let photos: Results<Photo>? = realmManager?.getObjects()
        
        return photos?.filter(NSPredicate(format: "owner_id CONTAINS[cd] %@", String(userID)))
    }
    var userID = -1
    let itemsPerRow: CGFloat = 2
    let sectionsInserds = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    let networkService = NetworkService.shared
    let realmManager = RealmManager.shared
    
    func  loadData() {
        
        networkService.loadPhotos(token: Session.shared.token, userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    try? self.realmManager?.add(objects: photos)
                    
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private var photoFriendsNotificationToken: NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        photoFriendsNotificationToken = photos?.observe  { [weak self] change in
            switch change {
            case .initial:
                self?.collectionView.reloadData()
            case let .update(results, deletions: deletions, insertions: insertions, modifications: modifications):
                #if DEBUG
                print("""
                    New count: \(results.count)
                    Deletions: \(deletions)
                    Insertions: \(insertions)
                    Modifications: \(modifications)
                    """)
                #endif
                
                
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    self?.collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    self?.collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
                
                
            case let .error(error):
                print(error)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendsCell", for: indexPath) as? PhotoFriendsCell else {fatalError()}
        let imageName = photos?[indexPath.item]
        let urlImg = imageName?.url
        
        cell.photoFriends.kf.setImage(with: URL(string: urlImg ?? ""))
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AnimatedFriendsPhotoViewController") as? AnimatedPhotoViewController  else { return}
        
        vc.photoCollection = Array(photos!)
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

