//
//  AlbumListViewModel.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation

class AlbumListViewModel {
    
    var networkService: NetworkService!
    var albumList = [Album]()
    var filteredList = [Album]()
    var sortList = [AlbumItem]()
    var searchItems = [String: String]()
    
    init(service: NetworkService) {
        networkService = service
    }
    
    func fetchAllAlbum(callback: @escaping(_ error: String?)-> ()) {
        networkService.fetchAlbum { [weak self] (_albumResult, _error) in
            guard let _ = self else {return}
            if let error = _error {
                callback(error)
                return
            }
            if let albumResult = _albumResult {
                self?.albumList = albumResult.getAlbumList()
                self?.filteredList = albumResult.getAlbumList()
                callback(nil)
            }
        }
    }
    
    func searchItem(searchDict: [String: String]) {
        // To get sorted response while search
        var list = sortItems(sortBy: sortList, _albumList: albumList.detached())
        if searchDict.isEmpty { return}
        searchItems = searchDict
        if let artistName = searchDict[AlbumItem.artistName.rawValue] {
            list = list.filter({($0.artistName?.lowercased().contains(artistName.lowercased())) ?? false})
        }
        if let trackName = searchDict[AlbumItem.trackName.rawValue] {
            list = list.filter({($0.trackName?.lowercased().contains(trackName.lowercased())) ?? false})
        }
        if let collectionName = searchDict[AlbumItem.collectionName.rawValue], !collectionName.isEmpty {
            list = list.filter({($0.collectionName?.lowercased().contains(collectionName.lowercased())) ?? false})
        }
        if let collectionPrice = searchDict[AlbumItem.collectionPrice.rawValue], !collectionPrice.isEmpty {
            list = list.filter({$0.collectionName == collectionPrice})
        }
        filteredList = list
    }
    
    func sortItems(sortBy _sortList:[AlbumItem], _albumList:[Album]? = nil) -> [Album] {
        if _sortList.isEmpty {
            filteredList = _albumList ?? filteredList
            return filteredList
        }
        self.sortList = _sortList
        var albums = _albumList ?? filteredList
        for sortTech in sortList {
            switch sortTech {
            case .artistName:
                albums.sort(by: {$0.artistName! < $1.artistName!})
            case .collectionName:
                albums.sort(by: {
                    if $0.collectionName != nil && $1.collectionName != nil {
                        return $0.collectionName! < $1.collectionName!
                    }
                    return ($0.collectionName != nil)
                })
            case .trackName:
                albums.sort(by: {
                    if $0.trackName != nil && $1.trackName != nil {
                        return $0.trackName! < $1.trackName!
                    }
                    return ($0.trackName != nil)
                })
            case .collectionPrice:
                albums.sort(by: {$0.collectionPrice < $1.collectionPrice})
            }
        }
        filteredList = albums
        return albums
    }
    
    func isSearchActive() -> Bool {
        return !searchItems.isEmpty
    }
    
    func isSortActive() -> Bool {
        return !sortList.isEmpty
    }
    
    func resetSort() {
        sortList.removeAll()
        self.searchItem(searchDict: searchItems)
    }
    
    func resetSearch() {
        searchItems.removeAll()
        _ = sortItems(sortBy: sortList, _albumList: albumList.detached())
    }
    
    func numberOfRows() -> Int {
        return filteredList.count
    }
    
    func getDataForRow(_ row: Int) -> Album? {
        return filteredList[row].detached()
    }
    
    func addToCart(row: Int, callback: (() -> ())?) {
        let album = filteredList[row]
        if album.isInvalidated { return }
        album.addToCart(callback: callback)
    }
    
    func removeFromCart(row: Int, callback: (() -> ())?) {
        let album = filteredList[row]
        if album.isInvalidated { return }
        album.removeFromCart(callback: callback)
    }
}
