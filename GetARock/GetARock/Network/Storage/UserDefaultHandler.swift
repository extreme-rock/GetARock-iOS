//
//  UserDefaultHandler.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/03/27.
//

import Foundation

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }
    
    static func setIsLogin(isLogin: Bool) {
        UserData.setValue(isLogin, forKey: .isLogin)
    }
    
    static func setUserID(userID: String) {
        UserData.setValue(userID, forKey: .userID)
    }
    
    static func setMemberID(memberID: Int) {
        UserData.setValue(memberID, forKey: .memberID)
    }
    
    static func setAccessToken(accessToken: String) {
        UserData.setValue(accessToken, forKey: .accessToken)
    }
    
    static func setRefreshToken(refreshToken: String) {
        UserData.setValue(refreshToken, forKey: .refreshToken)
    }
    
    static func setUserName(name: String) {
        UserData.setValue(name, forKey: .name)
    }

    static func setIdentityToken(identityToken: String) {
        UserData.setValue(identityToken, forKey: .identityToken)
    }
}
