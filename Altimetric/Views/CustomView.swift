//
//  CustomView.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {

    var imageUrlString: String?
    let networkManager: NetworkService = NetworkManager()

    func downloadImage(url: String, callback: @escaping(_ error: String?) -> ()) {
        imageUrlString = url
        image = nil
        DispatchQueue.global(qos: .background).async {
            self.networkManager.downloadImage(urlString: url) { [weak self] (_data, _error) in
                guard let _ = self else {return}
                if let error = _error {
                    callback(error)
                    return
                }
                if let data = _data {
                    guard let img = UIImage(data: data) else {return}
                    if self!.imageUrlString == url {
                        imageCache.setObject(img, forKey: url as NSString)
                        callback(nil)
                    }
                }
            }
        }
    }
}
