//
//  AnimatedPhotoViewController.swift
//  VKclient
//
//  Created by Mac on 29.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class AnimatedPhotoViewController: UIViewController {
    var currentIndex: Int = 0
    var photoCollection: [String] = []
    private var interectiveAnimator: UIViewPropertyAnimator!
    private var currentSign = 0
    private var percent: CGFloat = 0
    private let firstImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
  private let secondImage: UIImageView = {
         let view = UIImageView()
    view.contentMode = .scaleAspectFit
         view.clipsToBounds = true
         view.translatesAutoresizingMaskIntoConstraints = false
        
         return view
     }()
    
    
    private func layout(imgView: UIImageView) {
        view.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             imgView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.97),
            imgView.heightAnchor.constraint(equalTo: view.widthAnchor)
            
            ])
    }
   
   
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
      layout(imgView: secondImage)
    layout(imgView: firstImage)
    setImage()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        firstImage.addGestureRecognizer(gesture )
          
        }
   
        
       
    
    private func setImage() {
        let fImage = photoCollection[currentIndex]
        var nextIndex = currentIndex + 1
        var bImage: UIImage?
        if currentSign > 0 {
            nextIndex = currentIndex - 1
        }
        
        if nextIndex < photoCollection.count - 1, nextIndex >= 0 {
            bImage = UIImage(named: photoCollection[nextIndex])
        }
        firstImage.image = UIImage(named: fImage)
        secondImage.image = bImage
        secondImage.alpha = 0
    }
    
    

    private func initAnimator() {
        firstImage.alpha = 1.0
        secondImage.alpha = 0.0
        secondImage.transform = .init(scaleX: 0.8, y: 0.8)
        //secondImage.transform = .init(translationX: view.frame.width, y: 0)
        interectiveAnimator?.stopAnimation(true)
        interectiveAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
            let width = CGFloat(self.currentSign) * self.view.frame.width
            let widthTransform = CGAffineTransform(translationX: width , y: 0)
      let angle = CGFloat(self.currentSign) * 0.8
            let angleTransform = CGAffineTransform(rotationAngle: angle)
            self.firstImage.transform = angleTransform.concatenating(widthTransform)
           // self.firstImage.transform = widthTransform
            self.firstImage.alpha = 0.0
            self.secondImage.alpha = 1.0
            self.secondImage.transform = .identity
        })
        
        interectiveAnimator?.startAnimation()
        interectiveAnimator?.pauseAnimation()
    }
    
    private func resetImg() {
        secondImage.alpha = 0.0
        firstImage.alpha = 1.0
        secondImage.transform = .init(scaleX: 0.8, y: 0.8)
        //secondImage.transform = .init(translationX: view.frame.width, y: 0)
        firstImage.transform = .identity
        setImage()
        view.layoutIfNeeded()
        currentSign = 0
        interectiveAnimator = nil
    }
    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translatin = gesture.translation(in: view)
            percent = abs(translatin.x) / view.frame.width
            let translationX = Int(translatin.x)
            let sign = translationX == 0 ? 1 : translationX / abs(translationX)
            
            
            if interectiveAnimator == nil || sign != currentSign {
                interectiveAnimator?.stopAnimation(true)
                resetImg()
                interectiveAnimator = nil
                
                if (sign > 0 && currentIndex > 0 || (sign < 0 && currentIndex < photoCollection.count - 1)) {
                    currentSign = sign
                    setImage()
                    initAnimator()
                }
            }
            interectiveAnimator?.fractionComplete = abs(translatin.x) / (self.view.frame.width / 2)
        case .ended:
            interectiveAnimator?.addCompletion({ (position) in
                self.resetImg()
            })
            if percent < 0.33 {
                interectiveAnimator?.stopAnimation(true)
                UIView.animate(withDuration: 0.3)  {
                    self.resetImg()
                }
            }
            else {
                currentIndex += currentSign * -1
                interectiveAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            default:
                     break
            
        }
       
    }
}
