//
//  FriendsCell.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avaContView: UIView!
    @IBOutlet weak var avaImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    @IBInspectable var shadowCol: UIColor = .black {
        didSet {
               setNeedsDisplay()
        }
    }
    @IBInspectable var shadowOpas: Float = 0.5 {
           didSet {
                setNeedsDisplay()
           }
       }
    
    @IBInspectable var shadowRad: CGFloat = 5 {
        didSet {
              setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaContView.layer.cornerRadius = avaContView.bounds.width / 2
        avaContView.layer.shadowColor = shadowCol.cgColor
        avaContView.layer.shadowRadius = shadowRad
        avaContView.layer.shadowOpacity = shadowOpas
        avaContView.layer.shadowOffset = .zero
        avaContView.layer.shadowPath = UIBezierPath(ovalIn: avaContView.bounds).cgPath
        avaImage.layer.cornerRadius = avaContView.bounds.width / 2
        avaImage.clipsToBounds = true
        
    }
}
