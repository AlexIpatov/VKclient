//
//  Group.swift
//  VKclient
//
//  Created by Mac on 10.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation
import SwiftyJSON
class Group {
     
let id: Int
   let name: String
    let photo_200: String
    
 init(from json: JSON) {
   self.id = json["id"].intValue
 self.name = json["name"].stringValue
self.photo_200 = json["photo_200"].stringValue
    
}
}
 


/*


// MARK: - Group
struct Group: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let items: [Item]
    let count: Int
}

// MARK: - Item
struct Item: Codable {
    let isAdmin: Int
    let name: String
    let type: TypeEnum
    let screenName: String
    let isAdvertiser: Int
    let photo50, photo100: String
    let isMember, id: Int
    let photo200: String
    let isClosed: Int
    let adminLevel: Int?

    enum CodingKeys: String, CodingKey {
        case isAdmin
        case name, type
        case screenName
        case isAdvertiser
        case photo50
        case photo100
        case isMember
        case id
        case photo200
        case isClosed
        case adminLevel
    }
}

enum TypeEnum: String, Codable {
    case event = "event"
    case group = "group"
    case page = "page"
}



*/
