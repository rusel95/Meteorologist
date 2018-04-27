//
//  AuthFlowCoordinator.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

struct LoginFlowConfiguration {
    let parent: EventNode
    let userSessionController: UserSessionController
}

class LoginFlowCoordinator: EventNode, Coordinator {
    
    private unowned let userSessionController: UserSessionController
    
    init(configuration: LoginFlowConfiguration) {
        userSessionController = configuration.userSessionController
        
        super.init(parent: configuration.parent)
    }
    
    func createFlow() -> UIViewController {
        let loginController = StoryboardScene.Auth.instantiateLogin()
        let model = LoginModel(userSessionController: userSessionController, parent: self)
        loginController.model = model
        model.output = loginController
        
        return loginController
    }
    
}
