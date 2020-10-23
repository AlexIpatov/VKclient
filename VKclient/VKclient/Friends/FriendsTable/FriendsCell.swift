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
    
     var shadowRad: CGFloat = 4 {
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
         let gesture = UITapGestureRecognizer(target: self, action: #selector(onAvaTapped(_:)))
        avaImage.addGestureRecognizer(gesture)
        avaImage.isUserInteractionEnabled = true
        
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
            
            self.avaContView.layer.add(animation, forKey: nil)
        }

        
     

}

