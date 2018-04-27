//
//  UserSession.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

/// Inspired by https://github.com/dimazen/UserSessionSample
/// For more information see Dima's blog https://dimazen.github.io/blog/2015/08/using-user-session-in-ios/

class UserSession {
    
    enum State: Int {
        
        case initialized, opened, closed
    }
    
    let identifier: String
    
    var user: User {
        get {
            return sessionInfo.user
        }
        set {
            sessionInfo.user = newValue
            saveUser()
        }
    }
    
    var accessToken: String {
        get {
            return sessionInfo.accessToken
        }
        set {
            sessionInfo.accessToken = newValue
            saveAccessToken()
        }
    }
    
    private let sessionInfo: UserSessionInfo!
    private(set) var state: State = .initialized
    private let storage: KeyValueStorage
    
    // MARK: - Init
    
    init(sessionInfo: UserSessionInfo, storage: KeyValueStorage) {
        self.identifier = sessionInfo.identifier
        self.sessionInfo = sessionInfo
        self.storage = storage
    }
    
    init?(restorationID identifier: String, storage: KeyValueStorage) {
        let userStorageKey = UserSession.userStorageKey(for: identifier)
        let accessTokenStorageKey = UserSession.accessTokenStorageKey(for: identifier)
        
        guard let userInfo = storage.object(forKey: userStorageKey) as? [String: Any],
            let user = User(JSON: userInfo),
            let accessToken = storage.object(forKey: accessTokenStorageKey) as? String else {
                return nil
        }
        
        self.identifier = identifier
        self.sessionInfo = UserSessionInfo(user: user, accessToken: accessToken)
        self.storage = storage
    }
    
    // MARK: - Session Storage
    
    private static let storageIdentifier = "com.yalantis.ArchitectureGuideTemplate.userSession."
    
    private static func userStorageKey(for identifier: String) -> String {
        return storageIdentifier + "user." + identifier
    }
    
    private static func accessTokenStorageKey(for identifier: String) -> String {
        return storageIdentifier + "accessToken." + identifier
    }
    
    private func saveUser() {
        let userInfo = user.toJSON()
        storage.set(userInfo, forKey: UserSession.userStorageKey(for: identifier))
    }
    
    private func removeUser() {
        storage.set(nil, forKey: UserSession.userStorageKey(for: identifier))
    }
    
    private func saveAccessToken() {
        storage.set(accessToken, forKey: UserSession.accessTokenStorageKey(for: identifier))
    }
    
    private func removeAccessToken() {
        storage.set(nil, forKey: UserSession.accessTokenStorageKey(for: identifier))
    }
    
    // MARK: - State
    
    func open() {
        assert(state == .initialized, "Session can be opened once")
        
        saveUser()
        saveAccessToken()
        state = .opened
    }
    
    func close() {
        assert(state == .opened, "Only opened session can be closed")
        
        removeUser()
        removeAccessToken()
        state = .closed
    }
    
}

