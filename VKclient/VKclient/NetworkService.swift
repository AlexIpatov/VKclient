//
//  NetworkManager.swift
//  VKclient
//
//  Created by Mac on 11.08.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    static let session: Alamofire.Session = {
           let configuration = URLSessionConfiguration.default
           configuration.timeoutIntervalForRequest = 20
           let session = Alamofire.Session(configuration: configuration)
           return session
    
}()
}
var friendId = "-1"
func loadGroups(token: String) {
       let baseUrl = "https://api.vk.com"
       let path = "/method/groups.get"
       
       let params: Parameters = [
           "access_token": token,
           "extended": 1,
           "v": "5.92"
       ]
       
       NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
           guard let json = response.value else { return }
           
           print(json)
       }
   }
func loadFriends(token: String) {
    let baseUrl = "https://api.vk.com"
    let path = "/method/friends.get"
    
    let params: Parameters = [
        "access_token": token,
        "order": "hints",
        "v": "5.92"
    ]
    
    NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
        guard let json = response.value else { return }
        
        print(json)
    }
}
func loadPhotos(token: String) {
    let baseUrl = "https://api.vk.com"
    let path = "/method/photos.get"
    
    let params: Parameters = [
        "access_token": token,
        "owner_id": friendId,
        "album_id": "wall",
        "v": "5.122"
    ]
    
    NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
        guard let json = response.value else { return }
        
        print(json)
    }
}

func loadGroupsSearch(token: String, name: String) {
    let baseUrl = "https://api.vk.com"
    let path = "/method/groups.search"
    
    let params: Parameters = [
        "access_token": token,
        "q": name,
        "sort": 0,
        "v": "5.122"
    ]
    
    NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
        guard let json = response.value else { return }
        
        print(json)
    }
}
