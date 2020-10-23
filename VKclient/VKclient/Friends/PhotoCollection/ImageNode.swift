//
//  ImageNode.swift
//  VKclient
//
//  Created by Mac on 17.10.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ImageNode: ASCellNode {
    private let photoImageNode = ASNetworkImageNode()
    private let resource: Photo
    
    init(resource: Photo) {
        self.resource = resource
        
        super.init()
        setupSubnodes()
        backgroundColor = UIColor.black
        
    }
    private func setupSubnodes() {
        addSubnode(photoImageNode)
        photoImageNode.url = URL(string: resource.url)
        photoImageNode.contentMode = .scaleAspectFill
        
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        photoImageNode.style.preferredSize = CGSize(width: width, height: width*resource.aspectRatio)
        return ASWrapperLayoutSpec(layoutElement: photoImageNode)
    }
}



