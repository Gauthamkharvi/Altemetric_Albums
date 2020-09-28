//
//  SortFieldTableViewCell.swift
//  Altimetric
//
//  Created by gautham kharvi on 08/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import UIKit

class SortFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var sortSwitch: UISwitch!
    
    var switchUpdate: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sortSwitchAction(_ sender: Any) {
        switchUpdate?(sortSwitch.isOn)
        // Switch Toggle warning, follow: https://developer.apple.com/forums/thread/132035
    }
    
}
