//
//  CartViewController.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    var viewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        cartTableView.register(UINib(nibName: "AlbumCell", bundle: Bundle(for: AlbumCell.self)), forCellReuseIdentifier: "AlbumCell")
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.tableFooterView = UIView(frame: .zero)
        cartTableView.allowsSelection = false
    }
    
    func setupViewModel() {
        viewModel = CartViewModel()
        viewModel.fetchAlbumFromCart { [weak self] in
            self?.reloadData()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.cartTableView.reloadData()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumCell
        let album = viewModel.getAlbumfor(indexPath.row)
        cell?.updateData(album: album)    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFromCart(row: indexPath.row) { [weak self] in
                self?.reloadData()
            }
        }
    }
    
}
