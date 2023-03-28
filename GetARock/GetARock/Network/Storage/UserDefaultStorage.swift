//
//  UserDefaultStorage.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/03/25.
//

import Foundation

enum DataKeys: String, CaseIterable {
    case isLogin = "isLogin"
    case userID = "userID"
    case memberID = "memberID"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case name = "name"
}

struct UserDefaultStorage {
    static var isLogin: Bool {
        return UserData<Bool>.getValue(forKey: .isLogin) ?? false
    }
    
    static var userID: String {
        return UserData<String>.getValue(forKey: .userID) ?? ""
    }
    
    static var memberID: Int {
        return UserData<Int>.getValue(forKey: .memberID) ?? 0
    }
    
    static var accessToken: String {
        return UserData<String>.getValue(forKey: .accessToken) ?? ""
    }
    
    static var refreshToken: String {
        return UserData<String>.getValue(forKey: .refreshToken) ?? ""
    }

    static var name: String {
        return UserData<String>.getValue(forKey: .name) ?? ""
    }
}

struct UserData<T> {
    static func getValue(forKey key: DataKeys) -> T? {
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return data
        } else {
            return nil
        }
    }
    
    static func setValue(_ value: T, forKey key: DataKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func clearAll() {
        DataKeys.allCases.forEach { key in
            print(key.rawValue)
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    static func clear(forKey key: DataKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
}
