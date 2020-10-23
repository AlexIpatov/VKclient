//
//  RealmService.swift
//  VKclient
//
//  Created by Mac on 21.08.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import Foundation
import RealmSwift
class RealmManager {
    static let shared = RealmManager()
    private init?(){
        let configuration = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configuration) else {return nil}
        self.realm = realm
        print(realm.configuration.fileURL ?? "")
    }
    private let realm: Realm
    func add<T: Object>(objects: [T]) throws {
        try realm.write {
            realm.add(objects, update: .all)
        }
    }
    
    func getObjects<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
    func update(closure: @escaping (() -> Void)) throws {
        try realm.write {
            closure()
        }
    }
}
