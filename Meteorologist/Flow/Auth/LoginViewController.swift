//
//  AuthViewController.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewControllerOutput: LoginModelInput {}
protocol LoginViewControllerInput: LoginModelOutput {}

class LoginViewController: UIViewController {
    
    var model: LoginViewControllerOutput!
    
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.setTitle(tr(key: .authLoginButtonTitle), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        model.controllerDidBecomeVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        model.controllerDidBecomeHidden()
    }
    
    @IBAction private func login(_ sender: AnyObject) {
        model.performLoginAction()
    }
    
}

extension LoginViewController: LoginViewControllerInput {
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
