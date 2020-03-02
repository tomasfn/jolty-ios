//
//  CredentialManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Kingfisher

private enum Keys {
    static let credentials = "com.Jolty.credentials"
}

final class CredentialManager {
    
    static var shared = CredentialManager()
    
    private var refreshTimer: Timer?
    
    private var _currentCredential: Credential? { // Singleton
        didSet {
            
            refreshTimer?.invalidate()
            refreshTimer = nil
            
            if let _currentCredential = _currentCredential {
                
                // Refresh credentials 60 seconds before expiring
                let expireTime = max(_currentCredential.expiresIn - 60, 0)
                
                refreshTimer = Timer.scheduledTimer(timeInterval: expireTime, target: self, selector: #selector(refreshTimerFired), userInfo: nil, repeats: false)
            }
            
        }
    }
    
    var currentCredential: Credential? { // Getter/Setter
        get {
            if _currentCredential == nil,
                let credentialDict = UserDefaults.standard.dictionary(forKey: Keys.credentials) {
                _currentCredential = Credential.fromDict(dict: credentialDict as [String : AnyObject])
            }
            
            return _currentCredential
        }
        
        set {
            let ud = UserDefaults.standard
            ud.set(newValue?.dictionary, forKey: Keys.credentials)
            ud.synchronize()
            
            _currentCredential = newValue
        }
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    @objc private func refreshTimerFired() {
        debugPrint("Credential refresh timer fired")
        refreshAccessToken { (_) in }
    }
    
    func refreshAccessToken(completionBlock: @escaping (Bool) -> Void) {
        guard let currentCredential = currentCredential else {
            completionBlock(false)
            return
        }
        
        AuthenticationService.refreshAccessToken(credentials: currentCredential, invalidateOldToken: true) { (credential) in
            if let credential = credential, self.currentCredential != nil {
                self.currentCredential = credential
                debugPrint("Credential refreshed and updated")
            }
            
            completionBlock(credential != nil)
        }
    }
}

