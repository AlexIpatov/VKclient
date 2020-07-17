//
//  User.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit


struct User {
    let name: String
    let avatar: UIImage?
    let photos: [String]
   
    
}


var friends = [
  
    User(name: "Саша",avatar: UIImage(named: "manAva"), photos: alexPhoto),
      User(name: "Даша", avatar:  UIImage(named: "womanAva"), photos: dashaPhoto),
      User(name: "Алеша", avatar:  UIImage(named: "manAva"), photos: aleshaPhoto)
  ]


