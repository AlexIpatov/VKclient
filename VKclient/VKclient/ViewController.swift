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
    
    
      
      override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
          
          if identifier == "loginSegue" {
              if checkLoginInfo() {
                  return true
              }
              else {
                  showLoginError()
                  return false
              }
          }
          
          return true
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
    }
     

}

