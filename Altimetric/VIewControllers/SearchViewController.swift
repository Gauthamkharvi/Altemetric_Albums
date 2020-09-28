//
//  SearchViewController.swift
//  Altimetric
//
//  Created by gautham kharvi on 04/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var artistNameTextView: UITextField!
    @IBOutlet weak var artistNameConditionLabel: UILabel!
    @IBOutlet weak var trackNameTextView: UITextField!
    @IBOutlet weak var trackNameConditionLabel: UILabel!
    @IBOutlet weak var collectionNameTextView: UITextField!
    @IBOutlet weak var collectionPriceTextView: UITextField!
    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: SearchViewModel!
    weak var delegate: SearchItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        containerVIew.addGestureRecognizer(tapGesture)
        setupViewModel()
    }
    
    func setupViewModel() {
        viewModel = SearchViewModel()
    }
    
    func setDelegate() {
        artistNameTextView.delegate = self
        trackNameTextView.delegate = self
        collectionNameTextView.delegate = self
        collectionPriceTextView.delegate = self
    }
    
    @objc func didTapOutside() {
        self.artistNameTextView.resignFirstResponder()
        self.trackNameTextView.resignFirstResponder()
        self.collectionNameTextView.resignFirstResponder()
        self.collectionPriceTextView.resignFirstResponder()
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        var searchDict = [String: String]()
        guard let artistName = artistNameTextView.text, !artistName.isEmpty else {
            errorLabel.isHidden = false
            return
        }
        guard let trackName = trackNameTextView.text, !trackName.isEmpty else {
            errorLabel.isHidden = false
            return
        }
        if let collectionName = collectionNameTextView.text {
            searchDict[AlbumItem.collectionName.rawValue] = collectionName
        }
        if let collectionPrice = collectionPriceTextView.text {
            searchDict[AlbumItem.collectionPrice.rawValue] = collectionPrice
        }
        searchDict[AlbumItem.artistName.rawValue] = artistName
        searchDict[AlbumItem.trackName.rawValue] = trackName

        delegate?.searchItem(dict: searchDict)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func collectionSortSwitchAction(_ sender: Any) {
        if let collectionSwitch = sender as? UISwitch {
            viewModel.appendSortOption(sort: .collectionName, isOn: collectionSwitch.isOn)
        }
    }
    
    @IBAction func trackNameSortSwitchAction(_ sender: Any) {
        if let collectionSwitch = sender as? UISwitch {
            viewModel.appendSortOption(sort: .trackName, isOn: collectionSwitch.isOn)
        }
    }
    
    @IBAction func artistNameSortSwitchAction(_ sender: Any) {
        if let collectionSwitch = sender as? UISwitch {
            viewModel.appendSortOption(sort: .artistName, isOn: collectionSwitch.isOn)
        }
    }
    
    @IBAction func collectionPriceSortSwitchAction(_ sender: Any) {
        if let collectionSwitch = sender as? UISwitch {
            viewModel.appendSortOption(sort: .collectionPrice, isOn: collectionSwitch.isOn)
        }
    }
}
