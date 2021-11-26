//
//  UserDefaultPropertyWrapper.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import Foundation


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(UserDefaults.Keys.isShowTutorial, defaultValue: false)
    static var isShowTutorial: Bool
    
    @UserDefault(UserDefaults.Keys.authorization, defaultValue: false)
    static var isAuthorization: Bool
    
    @UserDefault(UserDefaults.Keys.accessToken, defaultValue: "")
    static var accessToken: String
    
    @UserDefault(UserDefaults.Keys.authorization, defaultValue: false)
    static var authorization: Bool
}
