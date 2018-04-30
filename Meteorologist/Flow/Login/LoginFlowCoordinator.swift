//
//  AuthFlowCoordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import EventsTree

struct LoginFlowConfiguration {
    let parent: EventNode
    //let userSessionController: UserSessionController?
}

class LoginFlowCoordinator: EventNode, Coordinator {
    
    //private unowned let userSessionController: UserSessionController
    
    init(configuration: LoginFlowConfiguration?) {
        //userSessionController = configuration.userSessionController
        super.init(parent: configuration?.parent)
    }
    
    func createFlow() -> UIViewController {
        let loginController = R.storyboard.login.authVC()!
        let model = LoginModel(parent: self)
        loginController.model = model
        model.output = loginController
        
        return loginController
    }
    
}
