//
//  SortViewModel.swift
//  Altimetric
//
//  Created by gautham kharvi on 09/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation

protocol SortItemProtocol: class {
    func sortItems(list: [AlbumItem])
}
class SortViewModel {
    
    var sortList = [AlbumItem]()
    var items:[AlbumItem] = [.artistName, .trackName, .collectionName, .collectionPrice]
    
    func getNumberOfSortOptions() -> Int {
        return items.count
    }
    
    func getSortOptionFor(row: Int) -> AlbumItem {
        return items[row]
    }
    
    func updateSortList(item: AlbumItem, isOn: Bool) {
        if isOn {
            addToSortList(item: item)
            return
        }
        removeFromSortList(item: item)
    }
    
    func addToSortList(item: AlbumItem) {
        if sortList.contains(item) {return}
        sortList.append(item)
    }
    
    func removeFromSortList(item: AlbumItem) {
        guard let ind = sortList.firstIndex(where: {$0 == item}) else {return}
        sortList.remove(at: ind)
    }
    
    func getSortList() -> [AlbumItem] {
        return sortList
    }
}
