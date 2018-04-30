//
//  SettingsViewController.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerReusableCell(cellType: SettingsTableViewCell.self)
        tableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfSettingsSectionDatas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTableViewCell = tableView.dequeueReusableCell(indexPath, cellType: SettingsTableViewCell.self)
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
        SVProgressHUD.showError(withStatus: message)
    }
    
    func presentSuccess(message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
    func presentStatus(message: String) {
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    func showSpinner(message: String?, blockUI: Bool) {
        SVProgressHUD.show(withStatus: message)
    }
    
    func hideSpinner() {
        SVProgressHUD.dismiss()
    }
}
