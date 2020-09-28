//
//  AlbumListViewController.swift
//  Altimetric
//
//  Created by gautham kharvi on 03/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class AlbumListViewController: UIViewController {

    @IBOutlet weak var albumCartTableView: UITableView!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    
    var viewModel: AlbumListViewModel!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(AlbumListViewController.handleRefresh(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCartTableView.addSubview(refreshControl)

        setupViewModel()
        albumCartTableView.register(UINib(nibName: "AlbumCell", bundle: Bundle(for: AlbumCell.self)), forCellReuseIdentifier: "AlbumCell")
        albumCartTableView.delegate = self
        albumCartTableView.dataSource = self
        albumCartTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupViewModel() {
        let service = NetworkManager()
        viewModel = AlbumListViewModel(service: service)
        fetchAlbum()
    }
    
    func fetchAlbum() {
        viewModel.fetchAllAlbum { [weak self] _error in
            guard let _ = self else {return}
            if let error = _error {
                self?.showError(message: error)
                return
            }
            DispatchQueue.main.async {
                self?.albumCartTableView.reloadData()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchAlbum()
        self.albumCartTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumCartTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if !viewModel.isSearchActive() {
            goToSearch()
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let clearSearch = UIAlertAction(title: "Clear search", style: .destructive) { [weak self] _ in
            self?.viewModel.resetSearch()
            self?.albumCartTableView.reloadData()
            self?.searchBarButton.tintColor = .systemBlue
        }
        let proceedSearch = UIAlertAction(title: "Search", style: .default) { [weak self] _ in
            self?.goToSearch()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(clearSearch)
        alert.addAction(proceedSearch)
        alert.addAction(cancel)
        // There is a bug from apple when presenting action sheet. can follow this thread https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        
        navigationController?.present(alert, animated: false, completion: nil)
    }
    
    func goToSearch() {
        let searchVC: SearchViewController = .instatiate()
        searchVC.delegate = self
        navigationController?.present(searchVC, animated: true, completion: nil)
    }
    
    @IBAction func cartButtonAction(_ sender: Any) {
        let cartVC: CartViewController = .instatiate()
        cartVC.modalPresentationStyle = .fullScreen
        navigationController?.present(cartVC, animated: true, completion: nil)
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        if !viewModel.isSortActive() {
            goToSortVC()
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let clearSearch = UIAlertAction(title: "Clear sort", style: .destructive) { [weak self] _ in
            self?.viewModel.resetSort()
            self?.albumCartTableView.reloadData()
            self?.sortBarButton.tintColor = .systemBlue
        }
        let proceedSearch = UIAlertAction(title: "Sort", style: .default) { [weak self] _ in
            self?.goToSortVC()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(clearSearch)
        alert.addAction(proceedSearch)
        alert.addAction(cancel)
        // There is a bug from apple when presenting action sheet. can follow this thread https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        
        navigationController?.present(alert, animated: false, completion: nil)
    }
    
    func goToSortVC() {
        let sortVC: SortViewController = .instatiate()
        sortVC.delegate = self
        navigationController?.present(sortVC, animated: true, completion: nil)
    }
}

extension AlbumListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumCell
        cell?.accessoryType = .none
        if let album = viewModel.getDataForRow(indexPath.row) {
            cell?.updateData(album: album)
            cell?.accessoryType = album.isInCart() ? .checkmark : .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        if cell?.accessoryType == .checkmark {
            viewModel.removeFromCart(row: indexPath.row) {
                cell?.accessoryType = .none
            }
        } else {
            viewModel.addToCart(row: indexPath.row) {
                cell?.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !viewModel.filteredList.isEmpty {
            return UIView(frame: .zero)
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60))
        let label = UILabel(frame: view.bounds)
        label.text = "No data available."
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    
}

extension AlbumListViewController: SearchItemProtocol {
    func searchItem(dict: [String : String]) {
        if dict.isEmpty {return}
        self.viewModel.searchItem(searchDict: dict)
        searchBarButton.tintColor = !dict.isEmpty ? .systemRed : .systemBlue
        self.albumCartTableView.reloadData()
    }
}

extension AlbumListViewController: SortItemProtocol {
    func sortItems(list: [AlbumItem]) {
        if list.isEmpty {return}
        _ = self.viewModel.sortItems(sortBy: list)//filteredData(sortList: list)
        sortBarButton.tintColor = !list.isEmpty ? .systemRed : .systemBlue
        self.albumCartTableView.reloadData()
    }
}
