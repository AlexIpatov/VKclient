//
//  NetworkManager.swift
//  VKclient
//
//  Created by Mac on 11.08.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
class NetworkService {
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
        
    }()
    
    let baseUrl = "https://api.vk.com"
    static let shared = NetworkService()
    var friendId = Session.shared.userId
    
    
    
    private lazy var realm: Realm? = {
        #if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm error")
        #endif
        
        return try? Realm()
    }()
    
    func loadGroups(token: String, completion: ((Result<[Group], Error>) -> Void)? = nil) {
        
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        
        NetworkService.session.request( baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let groupsJSONs = json["response"]["items"].arrayValue
                
                let groups = groupsJSONs.map { Group(from: $0) }
                self.saveGroups(groups)
                completion?(.success(groups))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    
    func loadFriends(token: String, completion: ((Result<[User], Error>) -> Void)? = nil) {
        
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "order": "hints",
            "fields": "photo_100",
            "v": "5.122"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let userJSONs = json["response"]["items"].arrayValue
                
                let friends = userJSONs.map { User(from: $0) }
                self.saveUsers(friends)
                completion?(.success(friends))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    
    func loadPhotos(token: String, userId: Int, completion: ((Result<[Photo], Error>) -> Void)? = nil) {
        
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "album_id": "profile",
            "v": "5.122"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let photosJSONs = json["response"]["items"].arrayValue
                
                let photos = photosJSONs.map { Photo(from: $0) }
                self.savePhotos(photos)
                completion?(.success(photos))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    
    func loadGroupsSearch(token: String, name: String, completion: ((Result<[Group], Error>) -> Void)? = nil) {
        
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": name,
            "sort": 0,
            "v": "5.122"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let groupsJSONs = json["response"]["items"].arrayValue
                
                let groups = groupsJSONs.map { Group(from: $0) }
                
                completion?(.success(groups))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    
    
    
    func saveGroups(_ groups: [Group]) {
        
        do {
            let realm = try Realm()
            try? realm.write{
                realm.add(groups)
            }
            print(realm.objects(Group.self))
            
        } catch {
            
            print(error)
        }
    }
    
    func savePhotos(_ photos: [Photo]) {
        
      
        do {
            let realm = try Realm()
            try? realm.write{
                realm.add(photos)
            }
            print(realm.objects(Photo.self))
        } catch {
            print(error)
        }
    }
    func saveUsers(_ users: [User]) {
        
        do {
            let realm = try Realm()
            try? realm.write{
                realm.add(users)
            }
            print(realm.objects(User.self))
        } catch {
            print(error)
        }
    }
    
}
