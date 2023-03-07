//
//  AppDelegate.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Bundle.main.apiKey)
        registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken
                     deviceToken: Data) {
        // TODO: 로그인이 된 상태 && 알림 권한 허용인 경우에만 서버에 토큰을 보내도록 수정
        self.sendDeviceTokenToServer(token: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError
                     error: Error) {
        print("An error has occurred while registering notifications: \(error.localizedDescription)")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate {
    // TODO: 알림 권한 받는 기능 삭제 후 머지 (현재는 테스트를 위해 추가해둔 상태)
    private func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            guard granted else {
                print("An error has occurred while requesting authorization for notification")
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
    }
    
    private func sendDeviceTokenToServer(token: Data) {
        let deviceTokenString = token.map { String(format: "%02x", $0) }.joined()
        let deviceToken = DeviceTokenDTO(memberId: 1, deviceToken: deviceTokenString)
        
        do {
            let headers = ["content-type": "application/json"]
            guard let url = URL(string: "https://api.ryomyom.com/apns/device-token") else {
                print("An error has occurred while creating URL")
                return
            }
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10)
            var encodedData = Data()
            
            do {
                let data = try JSONEncoder().encode(deviceToken)
                encodedData = data
            } catch {
                print("An error has occurred while encoding JSONObject: \(error.localizedDescription)")
            }
            
            request.httpMethod = "POST"
            request.httpBody = encodedData
            request.allHTTPHeaderFields = headers
            
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let error {
                    print("An error has occurred : \(error.localizedDescription)")
                } else {
                    print(String(data: data!, encoding: String.Encoding.utf8) ?? "no responce")
                }
            })
            
            dataTask.resume()
        }
    }
}
