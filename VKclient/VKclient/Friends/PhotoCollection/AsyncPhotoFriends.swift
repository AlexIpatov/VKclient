//
//  AsyncPhotoFriends.swift
//  VKclient
//
//  Created by Mac on 17.10.2020.
//  Copyright © 2020 Alexander. All rights reserved.


import UIKit
import Kingfisher
import RealmSwift
import AsyncDisplayKit

class AsyncPhotoFriends: ASDKViewController<ASDisplayNode>, ASTableDelegate, ASTableDataSource {
    private var photos = [Photo]()
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID)
        networkService.loadPhotos(token: Session.shared.token, userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(photos):
                self.insertPhotos(photos)
                DispatchQueue.main.async {
                    self.tableNode.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    override init() {
        super.init(node: ASTableNode())
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.allowsSelection = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var userID = -1
    let networkService = NetworkService.shared
    let realmManager = RealmManager.shared
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        photos.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    private func insertPhotos(_ photos: [Photo]) {
        let indexSet = IndexSet(integersIn: 0 ..< photos.count)
        self.photos.append(contentsOf: photos)
        tableNode.insertSections(indexSet, with: .none)
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photosForCell = photos[indexPath.section]
        if photosForCell.url.count != 0 {
            return { ImageNode(resource: photosForCell) }
        } else {
            return {ASCellNode()}
        }
    }
}




