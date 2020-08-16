//
//  User.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import SwiftyJSON


class  User {
    let id: Int
    let first_name: String
    let last_name: String
    let photo_100: String
    
     init(from json: JSON) {
       self.id = json["id"].intValue
     self.first_name = json["first_name"].stringValue
    self.last_name = json["last_name"].stringValue
    self.photo_100 = json["photo_100"].stringValue
        
}


}






