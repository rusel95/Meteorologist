//
//  UserSessionController.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation

class UserSessionController: GitHubAuthServiceInjectable, NetworkClientInjectable {
    
    var canRestoreUserSession: Bool {
        guard let identifier = userSessionIdentifier, !identifier.isEmpty else { return false }
        
        return true
    }
    
    private let storage: KeyValueStorage
    private static let userSessionIdentifierKey = "com.yalantis.ArchitectureGuideTemplate.userSession.identifier"
    
    private(set) var userSession: UserSession? {
        didSet {
            oldValue?.close()
            userSession?.open()
            
            userSessionIdentifier = userSession?.identifier
            gitHubAuthService.use(oauthToken: userSession?.accessToken)
        }
    }
    
    private var userSessionIdentifier: String? {
        get {
            return storage.object(forKey: UserSessionController.userSessionIdentifierKey) as? String
        }
        set {
            storage.set(newValue, forKey: UserSessionController.userSessionIdentifierKey)
            storage.saveChanges()
        }
    }
    
    // MARK: - Init
    
    /**
     - parameter storage: A storage that conforms to `KeyValueStorage` protocol
     */
    init(storage: KeyValueStorage) {
        self.storage = storage
    }
    
    // MARK: Session managment
    
    @discardableResult
    func openSession() -> Task<UserSession> {
        var accessToken: String!
        
        return gitHubAuthService.login(scope: [.repo, .user, .publicRepo])
            .continueOnSuccessWithTask { token -> Task<User> in
                accessToken = token
                return self.networkClient.execute(request: GetUserRequest())
            }
            .continueOnSuccessWith { user in
                let userSessionInfo = UserSessionInfo(user: user, accessToken: accessToken)
                let userSession = UserSession(sessionInfo: userSessionInfo, storage: UserDefaults.standard)
                self.userSession = userSession
                return userSession
        }
    }
    
    func closeSession() {
        assert(userSession != nil, "Can`t close nil session")
        
        userSession = nil
    }
    
    // MARK: - Session Restoration
    
    @discardableResult
    func restorePreviousSession() -> UserSession? {
        assert(userSession == nil, "Can`t open 2 sessions")
        
        guard canRestoreUserSession else { return nil }
        guard let identifier = userSessionIdentifier,
            !identifier.isEmpty,
            let session = UserSession(restorationID: identifier, storage: storage) else {
                return nil
        }
        
        self.userSession = session
        return session
    }
    
}
