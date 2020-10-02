//
//  AuthenticationManager.swift
//  Habitica
//
//  Created by Phillip on 29.08.17.
//  Copyright © 2017 HabitRPG Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import KeychainAccess
import Shared
import Habitica_API_Client

class AuthenticationManager: NSObject {

    @objc static let shared = AuthenticationManager()
    let localKeychain = Keychain(service: "com.habitrpg.ios.Habitica", accessGroup: "group.habitrpg.habitica")

    private var keychain: Keychain {
        return Keychain(server: "https://habitica.com", protocolType: .https)
            .accessibility(.afterFirstUnlock)
    }

    @objc var currentUserId: String? {
        get {
            // using this to bootstrap identification so user's don't have to re-log in
            guard let cuid = localKeychain["currentUserId"] else {
                let cuid = UserDefaults.standard.string(forKey: "currentUserId")
                localKeychain["currentUserId"] = cuid
                return cuid
            }
            return cuid
        }

        set(newUserId) {
            localKeychain["currentUserId"] = newUserId
            UserDefaults.standard.set(newUserId, forKey: "currentUserId")
            NetworkAuthenticationManager.shared.currentUserId = newUserId
            currentUserIDProperty.value = newUserId
            if newUserId != nil {
                RemoteLogger.shared.setUserID(newUserId ?? "")
                HabiticaAnalytics.shared.setUserID(newUserId)
            }
        }
    }

    var currentUserIDProperty = MutableProperty<String?>(nil)

    @objc var currentUserKey: String? {
        get {
            if let userId = currentUserId {
                let userKey = keychain[userId]
                if userKey != nil {
                    localKeychain[userId] = userKey
                    return userKey
                } else {
                    return localKeychain[userId]
                }
            }
            return nil
        }

        set(newKey) {
            if let userId = currentUserId {
                keychain[userId] = newKey
                localKeychain[userId] = newKey
            }
            NetworkAuthenticationManager.shared.currentUserKey = newKey
        }
    }

    override init() {
        super.init()
        currentUserIDProperty.value = currentUserId
    }

    @objc
    func hasAuthentication() -> Bool {
        return currentUserId?.isEmpty == false && currentUserKey?.isEmpty == false
    }

    @objc
    func setAuthentication(userId: String, key: String) {
        currentUserId = userId
        currentUserKey = key
        localKeychain[userId] = key
    }

    @objc
    func clearAuthenticationForAllUsers() {
        currentUserId = nil
        currentUserKey = nil
    }

    @objc
    func clearAuthentication(userId: String) {
        //Will be used once we support multiple users
        clearAuthenticationForAllUsers()
    }
}
