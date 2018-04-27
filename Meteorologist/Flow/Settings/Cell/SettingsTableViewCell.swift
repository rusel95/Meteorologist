//
//  SettingsTableViewCell.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(with sectionData: SettingsModel.DisplayableSettingsSectionData?) {
        guard let sectionData = sectionData else {
            return
        }
        
        titleLabel.text = sectionData.title
    }
    
}
