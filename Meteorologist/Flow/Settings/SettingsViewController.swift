//
//  SettingsViewController.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

//
//  SettingsViewController.swift
//  ArchitectureGuideTemplate
//
//  Created by Artem Havriushov on 10/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

// TODO: Move all Settings generation code to appropriate place (ViewModle, Model etc) if needed.
//       For Privacy Policy setting use SFSafariViewController (push it in pattern's appropriate way).

protocol SettingsViewControllerOutput: SettingsModelInput {}
protocol SettingsViewControllerInput: SettingsModelOutput {}

class SettingsViewController: UIViewController {
    
    var model: SettingsViewControllerOutput!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tr(key: .settingsTitle)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfSettingsSectionDatas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsTableViewCell, for: indexPath)!
        cell.setup(with: model.settingsSectionData(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.didSelectSection(at: indexPath.row)
    }
    
}

extension SettingsViewController: SettingsViewControllerInput {
    
    func presentError(message: String) {
        
    }
    
    func presentSuccess(message: String) {
        
    }
    
    func presentStatus(message: String) {
        
    }
    
    func showSpinner(message: String?, blockUI: Bool) {
        
    }
    
    func hideSpinner() {
        
    }
}
