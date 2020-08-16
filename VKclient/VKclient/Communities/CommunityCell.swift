//
//  CommunityCell.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import Kingfisher

class CommunitiesCell: UITableViewCell {
    
    @IBOutlet weak var communityName: UILabel!
    
    @IBOutlet weak var communityAvaView: UIView!
    @IBOutlet weak var communityImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
     
      var shadowCol: UIColor = .black {
           didSet {
                  setNeedsDisplay()
           }
       }
       var shadowOpas: Float = 0.3 {
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
           communityAvaView.layer.cornerRadius = communityAvaView.bounds.width / 2
           communityAvaView.layer.shadowColor = shadowCol.cgColor
           communityAvaView.layer.shadowRadius = shadowRad
           communityAvaView.layer.shadowOpacity = shadowOpas
           communityAvaView.layer.shadowOffset = .zero
           communityAvaView.layer.shadowPath = UIBezierPath(ovalIn: communityAvaView.bounds).cgPath
           communityImage.layer.cornerRadius = communityAvaView.bounds.width / 2
           communityImage.clipsToBounds = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onAvaTapped(_:)))
           communityImage.addGestureRecognizer(gesture)
           communityImage.isUserInteractionEnabled = true
           
       }
       
     @objc func onAvaTapped(_ gesture: UITapGestureRecognizer){
           let animation = CASpringAnimation(keyPath: "transform.scale")
       animation.fromValue = 0.7
               animation.toValue = 1
               animation.stiffness = 200
               animation.mass = 1
               animation.duration = 3
               animation.beginTime = CACurrentMediaTime()
               animation.fillMode = CAMediaTimingFillMode.backwards
               
               self.communityAvaView.layer.add(animation, forKey: nil)
           }

           
        
}
