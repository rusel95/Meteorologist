//
//  UserSessionInfo.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

class UserSessionInfo {
    
    let identifier: String
    var accessToken: String
    var user: User
    
    init(user: User, accessToken: String) {
        self.user = user
        self.identifier = String(user.id)
        self.accessToken = accessToken
    }
    
}
