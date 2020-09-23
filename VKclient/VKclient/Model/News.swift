//
//  News.swift
//  VKclient
//
//  Created by Mac on 21.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

struct News {
    var newsItems: [NewsItem]
    var newsProfiles: [NewsProfile]
    var newsGroups:  [NewsGroup]
}

class NewsItem: Object, Decodable {
     @objc dynamic var id: Int = 0
     @objc dynamic var newsText: String = ""
     @objc dynamic var newsPhoto: String = ""
     @objc dynamic var numberOfViews: Int = 0
    @objc dynamic var sizesCount: Int = 0
    
    
    convenience init(from json: JSON) {
        self.init()
           self.id = json["source_id"].intValue
        self.newsText = json["text"].stringValue
         self.sizesCount = json["attachments"][0]["photo"]["sizes"].count
        
        self.newsPhoto = json["attachments"][0]["photo"]["sizes"][sizesCount - 1]["url"].stringValue
        if self.newsPhoto == "" {
              self.sizesCount = json["attachments"][0]["link"]["photo"]["sizes"].count
             self.newsPhoto = json["attachments"][0]["link"]["photo"]["sizes"][sizesCount - 1]["url"].stringValue
        }
        self.numberOfViews = json["views"]["count"].count
      
       
        
         
         
        
    }
}
class NewsGroup: Object, Decodable {
    @objc dynamic var id: Int = 0
     @objc dynamic var groupAva: String = ""
     @objc dynamic var groupName: String = ""

  
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.groupAva = json["photo_100"].stringValue
        self.groupName = json["name"].stringValue
       
        
         
         
        
    }
}
class NewsProfile: Object, Decodable {
    @objc dynamic var id: Int = 0
     @objc dynamic var authorAva: String = ""
     @objc dynamic var authorName: String = ""
    
    convenience init(from json: JSON) {
        self.init()
         self.id = json["id"].intValue
        self.authorAva = json["photo_100"].stringValue
        self.authorName = json["first_name"].stringValue + " " + json["last_name"].stringValue
       
    }
}

