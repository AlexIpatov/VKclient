//
//  NewsTableViewCell.swift
//  VKclient
//
//  Created by Mac on 21.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var authorAvaView: UIView!
    @IBOutlet weak var authorAva: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsLextLabel: UILabel!
   
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var numberOfViews: UILabel!
    

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
