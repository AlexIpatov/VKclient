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
import PromiseKit
class NetworkService {
    static let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
        
    }()
    private static let groupsQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    let baseUrl = "https://api.vk.com"
    static let shared = NetworkService()
    var friendId = Session.shared.userId
    
    func loadGroups(token: String, completion: ((Swift.Result<[Group], Error>) -> Void)? = nil) {
        
        let requestOperation = BlockOperation {
            let path = "/method/groups.get"
            
            let params: Parameters = [
                "access_token": token,
                "extended": 1,
                "v": "5.92"
            ]
   
            let responseOperation = BlockOperation {
                NetworkService.session.request( self.baseUrl + path, method: .get, parameters: params).responseJSON { response in
                   
                        switch response.result {
                        case .success(let data):
                            let json = JSON(data)
                            let groupsJSONs = json["response"]["items"].arrayValue
                            
                            let groups = groupsJSONs.map { Group(from: $0) }
                            
                            try? RealmManager.shared?.add(objects: groups)
                            
                            completion?(.success(groups))
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion?(.failure(error))
                        }
                    }
                 
            }
            NetworkService.groupsQueue.addOperation(responseOperation)
        }
        NetworkService.groupsQueue.addOperation(requestOperation)
    }
    func loadFriends(token: String) -> Promise<[User]> {
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token": token,
            "order": "hints",
            "fields": "photo_100",
            "v": "5.122"
        ]
        return Promise { resolver in
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let userJSONs = json["response"]["items"].arrayValue
                let friends = userJSONs.map { User(from: $0) }
                try? RealmManager.shared?.add(objects: friends)
                resolver.fulfill(friends)
            case .failure(let error):
                resolver.reject(error)
            }
        }
    }
    }
    func loadPhotos(token: String, userId: Int, completion: ((Swift.Result<[Photo], Error>) -> Void)? = nil) {
        
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
              //  try? RealmManager.shared?.add(objects: photos)
                completion?(.success(photos))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    
    func loadGroupsSearch(token: String, name: String, completion: ((Swift.Result<[Group], Error>) -> Void)? = nil) {
        
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
    
    func loadNews(token: String, completion: ((Swift.Result<News, Error>) -> Void)? = nil) {
        
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "filters": "post",
            "max_photos": "1",
            "count": "10",
            "v": "5.124"
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON(queue: .global(qos: .utility)) { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                var newsItems = [NewsItem]()
                var groups = [NewsGroup]()
                var profiles = [NewsProfile]()
                var nextFrom = ""
                let jsonParseGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let newsJSONs = json["response"]["items"].arrayValue
                    newsItems = newsJSONs.map { NewsItem(from: $0) }
                }
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let groupsJSONs = json["response"]["groups"].arrayValue
                    groups = groupsJSONs.map { NewsGroup(from: $0) }
                }
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let profileJSONs = json["response"]["profiles"].arrayValue
                    profiles = profileJSONs.map { NewsProfile(from: $0) }
                    
                DispatchQueue.global().async(group: jsonParseGroup) {
                                  nextFrom = json["response"]["next_from"].stringValue
                    Session.shared.nextFrom = nextFrom
                              }
                }
                jsonParseGroup.notify(queue: DispatchQueue.main) {
                    let news = News(newsItems: newsItems, newsProfiles: profiles, newsGroups: groups)
                    completion?(.success(news))
                }
            
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
    func loadPartNews(token: String, startFrom: String, completion: ((Swift.Result<News, Error>) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post,photo",
            "start_from": startFrom,
            "count": "10",
            "access_token":token,
            "v": "5.124"
        ]
        let url = baseUrl + path
        
        NetworkService.session.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var newsItems = [NewsItem]()
                var groups = [NewsGroup]()
                var profiles = [NewsProfile]()
                var nextFrom = ""
 
                let jsonParseGroup = DispatchGroup()
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let newsJSONs = json["response"]["items"].arrayValue
                    newsItems = newsJSONs.map { NewsItem(from: $0) }
                }
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let groupsJSONs = json["response"]["groups"].arrayValue
                    groups = groupsJSONs.map { NewsGroup(from: $0) }
                }
                DispatchQueue.global().async(group: jsonParseGroup) {
                    let profileJSONs = json["response"]["profiles"].arrayValue
                    profiles = profileJSONs.map { NewsProfile(from: $0) }
                    
                    DispatchQueue.global().async(group: jsonParseGroup) {
                        nextFrom = json["response"]["next_from"].stringValue
                        Session.shared.nextFrom = nextFrom
                    }
                }
                    jsonParseGroup.notify(queue: DispatchQueue.main) {
                        let news = News(newsItems: newsItems, newsProfiles: profiles, newsGroups: groups)
                        completion?(.success(news))
                    }
                    case .failure(let error):
                    print(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
    }
}

