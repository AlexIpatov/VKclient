//
//  LikeControl.swift
//  VKclient
//
//  Created by Mac on 16.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit


@IBDesignable class LikeControl: UIControl {

    
  
    private var count: Int = 0
    
    private let countLable = UILabel()
    private let imageView = UIImageView()
    
    
    func addLikeView() {
      imageView.translatesAutoresizingMaskIntoConstraints = false
            countLable.translatesAutoresizingMaskIntoConstraints = false
              addSubview(imageView)
              addSubview(countLable)
              
    
              let imageConstrainst = [
                  imageView.leftAnchor.constraint(equalTo: leftAnchor),
                  imageView.rightAnchor.constraint(equalTo: countLable.leftAnchor),
                  imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                  imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                  imageView.heightAnchor.constraint(equalToConstant: 30)
                      
              ]
              
              let lableConstraint = [
                  countLable.rightAnchor.constraint(equalTo: rightAnchor),
                  countLable.centerYAnchor.constraint(equalTo: centerYAnchor)
              ]
 
         NSLayoutConstraint.activate(lableConstraint + imageConstrainst)
            
             
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
               countLable.text = "\(count)"
        if isSelected {
            imageView.image = UIImage(systemName: "heart.fill")
        }
        else {
              imageView.image = UIImage(systemName: "heart")
        }
    }
    
    @objc func onHeartTapped(_ gesture: UITapGestureRecognizer){
        isSelected = !isSelected
        count += isSelected ? 1 : -1
        updateCount()
        sendActions(for: .valueChanged)
    }
   
    

}
