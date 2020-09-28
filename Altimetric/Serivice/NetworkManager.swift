//
//  NetworkManager.swift
//  Altimetric
//
//  Created by gautham kharvi on 03/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

enum Errors : String {
    case UnknownError = "Unknown error"
    case DownloadFail = "Download fail.!"
    case NetworkError = "The internet connection appears to be offline"
}

protocol NetworkService {
    func fetchAlbum(callback: @escaping(_ city: AlbumResult?, _ error: String?) -> ())
    func downloadImage(urlString: String, callback: @escaping(_ data: Data?, _ error: String?) -> ())
}

import Foundation

class NetworkManager: NetworkService {
    
    func fetchAlbum(callback: @escaping (AlbumResult?, String?) -> ()) {
        let urlString = ServiceUrls.searchAllAlbumURL
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (_data, _response, _error) in
            
            guard let response = _response as? HTTPURLResponse else {
                callback(nil, _error?.localizedDescription ?? Errors.UnknownError.rawValue)
                return
            }
            if let error = _error {
                callback(nil, error.localizedDescription)
                return
            }
            if response.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: _data!)
                    
                    Album.save(albums: result.getAlbumList()) {
                        callback(result, nil)
                    }
                } catch {
                    callback(nil, error.localizedDescription)
                }
            }
            
        }.resume()

    }

    func downloadImage(urlString: String, callback: @escaping(_ data: Data?, _ error: String?) -> ()) {
        guard let url = URL(string: urlString) else {return}

        let urlSession = URLSession.shared
        urlSession.dataTask(with: url) { (_data, _response, _error) in
            guard let response = _response as? HTTPURLResponse else { return }
            guard let data = _data else { return }

            if response.statusCode == 200 {
                callback(data, nil)
            } else {
                callback(nil, Errors.DownloadFail.rawValue)
            }
        }.resume()

    }

}
