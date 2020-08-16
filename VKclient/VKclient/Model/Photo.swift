//
//  Photo.swift
//  VKclient
//
//  Created by Mac on 10.07.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit
import SwiftyJSON
class Photo {
  
    let url: String
 init(from json: JSON) {
    
  
    
    self.url = json["sizes"][6]["url"].stringValue
    
}
}
 
