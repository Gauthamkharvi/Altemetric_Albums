//
//  Album.swift
//  Altimetric
//
//  Created by gautham kharvi on 03/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

let Album_Update_Thread = "AlbumThread"

class Album: Object, Codable {
    
    @objc dynamic var artistName: String!
    @objc dynamic var collectionName: String!
    @objc dynamic var trackName: String!
    @objc dynamic var artworkUrl100: String!
    @objc dynamic var collectionPrice: Double = 0.0
    @objc dynamic var releaseDate: String! // Standard formate
    @objc dynamic var inCart: Bool = false
    
    func getCollectionPrice() -> String {
        return "$ \(collectionPrice)"
    }
    
    override public class func primaryKey() -> String {
        return "trackName"
    }
    
    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case trackName
        case artworkUrl100
        case collectionPrice
        case releaseDate
    }
    
    class func save(albums: [Album], callback: (() -> ())?) {
        DispatchQueue(label: Album_Update_Thread).sync {
            let realm = try? Realm()
            try! realm?.write {
                realm?.add(albums, update: .all)
                callback?()
            }
        }
    }
    
    func addToCart(callback: (() -> ())?) {
        DispatchQueue(label: Album_Update_Thread).sync {
            let realm = try? Realm()
            try! realm?.write {
                self.inCart = true
                realm?.add(self, update: .all)
                callback?()
            }
        }
    }
    
    func removeFromCart(callback: (() -> ())?) {
        DispatchQueue(label: Album_Update_Thread).sync {
            let realm = try? Realm()
            try! realm?.write {
                self.inCart = false
                realm?.add(self, update: .all)
                callback?()
            }
        }
    }
    
    class func fetchCartData(callback: @escaping ([Album]) -> ()) {
        DispatchQueue(label: Album_Update_Thread).async {
            let realm = try? Realm()
            let albums = realm?.objects(Album.self).detached().filter({$0.inCart == true}) ?? []
            callback(albums)
        }
    }
    
    func isInCart() -> Bool {
        return inCart
    }
    
}
