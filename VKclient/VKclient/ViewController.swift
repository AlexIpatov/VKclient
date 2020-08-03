//
//  ViewController.swift
//  VKclient
//
//  Created by Mac on 01.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var vkLOgo: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
     
     var firstPoint: UIView = UIView()
       var secondPoint: UIView = UIView()
       var thirdPoint: UIView = UIView()
 
    
    private func checkLoginInfo() -> Bool {
          guard let loginText = loginTextField.text else { return false }
          guard let pwdText = passwordTextField.text else { return false }
          
          if loginText == "admin", pwdText == "1234" {
              return true
          }
          else {
              return false
          }
      }
      
    private func showLoginError() {
        let alert = UIAlertController(title: "Ошибка!", message: "Вы ввели неверные логин или пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func enter(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "tabBarVC") else {return }
        if checkLoginInfo() {
            vc.transitioningDelegate = self
                     present(vc, animated: true, completion: nil)
                        
                    }
                    else {
                        showLoginError()
                        
                    }
       
    }
    
    

      
    
  
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
         scrollView.addGestureRecognizer(tapGesture)
     }
     
     @objc func keyboardWillShown(notification: Notification) {
         let info = notification.userInfo! as NSDictionary
         let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
         
         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0)
         
         scrollView.contentInset = contentInsets
         scrollView.scrollIndicatorInsets = contentInsets
     }
     
     @objc func keyboardWillHide(notification: Notification) {
         scrollView.contentInset = UIEdgeInsets.zero
         scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
     }
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
        
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
     }
     
     @objc func hideKeyboard() {
         scrollView.endEditing(true)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkLOgo.image = UIImage.init(named: "VkLogo")
        view.backgroundColor = .lightGray
    }
    
    
    
      
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addthreePoint()
        
        UIView.animate(withDuration: 1.1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.firstPoint.alpha = 0
           
            
        })
        UIView.animate(withDuration: 1.1, delay: 0.6, options: [.repeat, .autoreverse], animations: {
                  self.secondPoint.alpha = 0
               
                  
              })
        UIView.animate(withDuration: 1.1, delay: 1.1, options: [.repeat, .autoreverse],  animations: {
                   self.thirdPoint.alpha = 0
             
                   
               })
    }
      
      func addthreePoint() {
        firstPoint.frame =  CGRect(x: (view.frame.width - 100) / 2, y: view.frame.height - 350, width: 20, height: 20)
        secondPoint.frame = CGRect(x: (view.frame.width - 20) / 2, y: view.frame.height - 350, width: 20, height: 20)
        thirdPoint.frame =  CGRect(x: (view.frame.width + 60 ) / 2, y: view.frame.height - 350, width: 20, height: 20)
        
        firstPoint.backgroundColor = .darkGray
        firstPoint.layer.cornerRadius = firstPoint.bounds.width / 2
          secondPoint.backgroundColor = firstPoint.backgroundColor
         secondPoint.layer.cornerRadius = firstPoint.bounds.width / 2
          thirdPoint.backgroundColor = firstPoint.backgroundColor
         thirdPoint.layer.cornerRadius = firstPoint.bounds.width / 2
        
        
   
       
        
        view.addSubview(firstPoint)
        view.addSubview(secondPoint)
        view.addSubview(thirdPoint)
        
        
        
      }


  
}


extension LoginViewController:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PushAnimator()
        
    }
    }

