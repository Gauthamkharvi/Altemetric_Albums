//
//  AlbumResult.swift
//  Altimetric
//
//  Created by gautham kharvi on 28/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumResult: Object, Codable {
    @objc dynamic var resultCount =  Int()
    dynamic var results = RealmSwift.List<Album>()
    
    func getResultCount() -> Int {
        return getAlbumList().count
    }
    
    func getAlbumList(sortBy _sortList:[AlbumItem]? = nil) -> [Album] {
        return Array(results.detached())
    }
}
