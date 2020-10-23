//
//  LikeControl.swift
//  VKclient
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit


@IBDesignable class LikeControl: UIControl {

    private let imageView = UIImageView()
    func addLikeView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        let imageConstrainst = [
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(imageConstrainst)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onHeartTapped(_:)))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        updateCount()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addLikeView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addLikeView()
    }
    private func updateCount() {

       if isSelected {
            imageView.image = UIImage(systemName: "heart.fill")
        }
        else {
            imageView.image = UIImage(systemName: "heart")
        }
   }
    @objc func onHeartTapped(_ gesture: UITapGestureRecognizer){
        isSelected = !isSelected
        updateCount()
        sendActions(for: .valueChanged)
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.4
        animation.toValue = 1
        animation.stiffness = 150
        animation.mass = 1.5
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.imageView.layer.add(animation, forKey: nil)
    }
}
