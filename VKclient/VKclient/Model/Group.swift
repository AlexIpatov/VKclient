//
//  Group.swift
//  VKclient
//
//  Created by Mac on 10.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo_200: String = ""
    
    convenience init(id: Int, name: String, photo_200: String) {
        self.init()
        self.id = id
        self.name = name
        self.photo_200 = photo_200
    }
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_200 = json["photo_200"].stringValue
        
    }
    override class func primaryKey() -> String? {
        "id"
    }
    
}
