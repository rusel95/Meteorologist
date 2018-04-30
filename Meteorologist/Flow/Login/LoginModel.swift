//
//  LoginModel.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
//import BoltsSwift
//import Template
import EventsTree

enum LoginEvent: Event {
    //case successfulLogin(session: UserSession)
    case successfulLogin()
}

protocol LoginModelInput: ControllerVisibilityOutput {
    
    func performLoginAction()
    
}

protocol LoginModelOutput: class, ModelOutput {}

class LoginModel: Model {
    
    weak var output: LoginModelOutput!
    //fileprivate let userSessionController: UserSessionController
    
//    init(userSessionController: UserSessionController, parent: EventNode) {
//        self.userSessionController = userSessionController
//
//        super.init(parent: parent)
//    }
    init(parent: EventNode) {
        super.init(parent: parent)
    }
}

extension LoginModel: LoginModelInput, LoginViewControllerOutput {
    
    func performLoginAction() {
        let event = LoginEvent.successfulLogin()
        self.raise(event: event)
//        output.showSpinner(message: nil, blockUI: true)
//
//        let task = userSessionController.openSession()
//        task.continueWith(.mainThread) { [weak self] task in
//            guard let `self` = self else {
//                return
//            }
//
//            self.output.hideSpinner()
//            if let userSession = task.result {
//                let event = LoginEvent.successfulLogin(session: userSession)
//                self.raise(event: event)
//            } else if let error = task.error {
//                self.output.presentError(message: error.localizedDescription)
//            }
//        }
    }
    
}
