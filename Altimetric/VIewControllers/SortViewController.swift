//
//  SortViewController.swift
//  Altimetric
//
//  Created by gautham kharvi on 08/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {

    @IBOutlet weak var sortFieldTableView: UITableView!
    
    var viewModel: SortViewModel!
    weak var delegate: SortItemProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SortViewModel()
        sortFieldTableView.tableFooterView = UIView(frame: .zero)
        sortFieldTableView.delegate = self
        sortFieldTableView.dataSource = self
    }
    
    @IBAction func submitButtonAction() {
        delegate?.sortItems(list: viewModel.getSortList())
        cancelButtonAction()
    }
    
    @IBAction func cancelButtonAction() {
        self.dismiss(animated:true, completion: nil)
    }
    
}
extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfSortOptions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortFieldTableViewCell") as? SortFieldTableViewCell
        let sortItem = viewModel.getSortOptionFor(row: indexPath.row)
        cell?.sortTypeLabel.text = sortItem.rawValue.capitalized
        cell?.switchUpdate = { [weak self] isOn in
            self?.viewModel.updateSortList(item: sortItem, isOn: isOn)
        }
        return cell!
    }
}
