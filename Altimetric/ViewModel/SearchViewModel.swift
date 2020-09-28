//
//  SearchViewModel.swift
//  Altimetric
//
//  Created by gautham kharvi on 06/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation

protocol SearchItemProtocol: class {
    func searchItem(dict: [String: String])
}

class SearchViewModel {
    
    var sortList = [AlbumItem]()
    
    func appendSortOption(sort: AlbumItem, isOn: Bool) {
        if isOn {
            sortList.append(sort)
        } else {
            if let ind = sortList.lastIndex(where: { $0 == sort}) {
                sortList.remove(at: ind)
            }
        }
    }
}
