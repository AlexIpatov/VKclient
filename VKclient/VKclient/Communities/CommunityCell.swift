//
//  CommunityCell.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit


class CommunitiesCell: UITableViewCell {
    
    @IBOutlet weak var communityName: UILabel!
    
    @IBOutlet weak var communityImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
