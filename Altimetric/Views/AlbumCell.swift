//
//  AlbumCell.swift
//  Altimetric
//
//  Created by gautham kharvi on 04/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var artistName:UILabel!
    @IBOutlet weak var collectionName:UILabel!
    @IBOutlet weak var releaseDate:UILabel!
    @IBOutlet weak var trackName:UILabel!
    @IBOutlet weak var collectionPrice:UILabel!
    @IBOutlet weak var albumImageView:CustomImageView!
    
    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(frame: CGRect.init(x: 20, y: 45, width: 20, height: 20))
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        artistName.text = ""
        collectionName.text = ""
        releaseDate.text = ""
        trackName.text = ""
        collectionPrice.text = ""
        albumImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData(album: Album) {
        artistName.text = album.artistName
        collectionName.text = album.collectionName
        releaseDate.text = album.releaseDate
        trackName.text = album.trackName
        collectionPrice.text = album.getCollectionPrice()

        if let imgUrl = album.artworkUrl100 {
            if let img = imageCache.object(forKey: imgUrl as NSString) {
                self.indicatorView.stopAnimating()
                self.albumImageView.image = img
                return
            }
            setupActivityIndicator()
            self.downloadImage(imgUrl: imgUrl)
        }
    }
    
    func setupActivityIndicator() {
        indicatorView.removeFromSuperview()
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
    }
    
    func downloadImage(imgUrl: String) {
        albumImageView.downloadImage(url: imgUrl, callback: { [weak self] _error in
            guard let _ = self else {return}
            DispatchQueue.main.async {
                if _error == nil {
                    if let img = imageCache.object(forKey: imgUrl as NSString) {
                        self?.indicatorView.stopAnimating()
                        self?.albumImageView.image = img
                        return
                    }
                } else {
                    self?.indicatorView.stopAnimating()
                }
            }
        })
    }

}
