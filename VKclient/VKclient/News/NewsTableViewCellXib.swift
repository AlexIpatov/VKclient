//
//  TableViewCell.swift
//  VKclient
//
//  Created by Mac on 09.08.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class NewsTableViewCellXib: UITableViewCell {
    
    @IBOutlet weak var authorAvaView: UIView!
    @IBOutlet weak var authorAva: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var commentsLablel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var countsOfLikeLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonShowConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreButton: UIButton!
    
    var shadowCol: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    var shadowOpas: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    var shadowRad: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        authorAvaView.layer.cornerRadius = authorAvaView.bounds.width / 2
        authorAvaView.layer.shadowColor = shadowCol.cgColor
        authorAvaView.layer.shadowRadius = shadowRad
        authorAvaView.layer.shadowOpacity = shadowOpas
        authorAvaView.layer.shadowOffset = .zero
        authorAva.layer.shadowPath = UIBezierPath(ovalIn: authorAvaView.bounds).cgPath
        authorAva.layer.cornerRadius = authorAvaView.bounds.width / 2
        authorAva.clipsToBounds = true
    }
}


