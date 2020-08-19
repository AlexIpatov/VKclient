//
//  User.swift
//  VKclient
//
//  Created by Mac on 08.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class  User: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_100: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        
    }
    convenience init(id: Int, first_name: String, last_name: String, photo_100: String) {
        self.init()
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.photo_100 = photo_100
    }
    
}






