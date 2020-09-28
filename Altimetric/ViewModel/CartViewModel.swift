//
//  CartViewModel.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation
import RealmSwift

class CartViewModel {
    
    var cartAlbums = [Album]()
    
    func fetchAlbumFromCart(callback: @escaping() -> ()?) {
        Album.fetchCartData(callback: { cartData in
            self.cartAlbums = cartData
            callback()
        })
    }
    
    func getNumberOfRows() -> Int {
        return cartAlbums.count
    }
    
    func getAlbumfor(_ row: Int) -> Album {
        return cartAlbums[row].detached()
    }
    
    func removeFromCart(row: Int, callback: @escaping() -> ()) {
        let album = cartAlbums[row]
        album.removeFromCart { [weak self] in
            self?.fetchAlbumFromCart {
                callback()
            }
        }
   }
}
