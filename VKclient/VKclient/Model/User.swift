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
   
    
}


var friends = [
      
    User(name: "Саша",avatar: UIImage(named: "manAva")),
      User(name: "Даша", avatar:  UIImage(named: "womanAva")),
      User(name: "Алеша", avatar:  UIImage(named: "manAva"))
  ]


