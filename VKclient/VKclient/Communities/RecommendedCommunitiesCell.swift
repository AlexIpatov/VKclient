//
//  RecommendedCommunitiesCell.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class recommendedCommunitiesCell: UITableViewCell {
    @IBOutlet weak var recommendedCommunityImage: UIImageView!
    @IBOutlet weak var recommendedCommunityName: UILabel!
    @IBOutlet weak var recomendedAvaView: UIView!
    
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
        recomendedAvaView.layer.cornerRadius = recomendedAvaView.bounds.width / 2
        recomendedAvaView.layer.shadowColor = shadowCol.cgColor
        recomendedAvaView.layer.shadowRadius = shadowRad
        recomendedAvaView.layer.shadowOpacity = shadowOpas
        recomendedAvaView.layer.shadowOffset = .zero
        recomendedAvaView.layer.shadowPath = UIBezierPath(ovalIn: recomendedAvaView.bounds).cgPath
        recommendedCommunityImage.layer.cornerRadius = recomendedAvaView.bounds.width / 2
        recommendedCommunityImage.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onAvaTapped(_:)))
        recommendedCommunityImage.addGestureRecognizer(gesture)
        recommendedCommunityImage.isUserInteractionEnabled = true
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
        
        self.recomendedAvaView.layer.add(animation, forKey: nil)
    } 
}



