//
//  Photo.swift
//  VKclient
//
//  Created by Mac on 10.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
class Photo: Object, Decodable {
    @objc dynamic var sizesCount: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var owner_id: String = ""


    convenience init(from json: JSON) {
        self.init()
        self.sizesCount = json["sizes"].count
        self.url = json["sizes"][sizesCount-1]["url"].stringValue
        self.owner_id = json["owner_id"].stringValue
        
    }
    convenience init(sizesCount: Int, url: String) {
        self.init()
        self.sizesCount = sizesCount
        self.url = url
        self.owner_id = owner_id
    }
    override class func ignoredProperties() -> [String] {
        ["sizesCount"]
    }
    override class func primaryKey() -> String? {
      "url"
      }
}

