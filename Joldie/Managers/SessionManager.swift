//
//  SessionManager.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/30/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import Foundation
import Kingfisher


typealias SessionIdentifier = String

private let sessionIdentifierKey = "com.Jolty.Jolty_SessionManager_SessionIdentifier"

var sessionIdentifier: SessionIdentifier? {
    get { return ud.string(forKey: sessionIdentifierKey) }
    set { ud.set(newValue, forKey: sessionIdentifierKey) }
}

private var ud: UserDefaults {
    get { return UserDefaults.standard}
}

typealias RefreshToken = String

private let refreshTokenKey = "com.Jolty.Jolty_SessionManager_RefreshToken"

var refreshToken: RefreshToken? {
    get { return ud.string(forKey: refreshTokenKey) }
    set { ud.set(newValue, forKey: refreshTokenKey) }
}

let credentialData = "0192837465:1029384756".data(using: String.Encoding.utf8)!
let base64Credentials = credentialData.base64EncodedString(options: ([]))

var oauthHandler = OAuth2Handler(
    baseURLString: SharedInfo.baseURL,
    accessToken: sessionIdentifier!,
    refreshToken: refreshToken!
)
