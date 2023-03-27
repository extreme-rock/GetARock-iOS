//
//  AppDelegate.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import AuthenticationServices
import UIKit

import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Bundle.main.apiKey)
        getCredentialState()
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

// MARK: - 애플 로그인 상태 체크

extension AppDelegate {
    private func getCredentialState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaultStorage.userID) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // TODO: isLogin 값 체크 후 자동로그인 (refresh token 필요함)
                print("authorized")
//                DispatchQueue.main.async {
//                    self.presentMaipMapViewController()
//                }
            // The Apple ID credential is valid.
            case .revoked:
                print("revoked")
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
            default:
                break
            }
        }
    }
}

extension AppDelegate {

    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
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

extension AppDelegate {
    private func presentMaipMapViewController() {
        let viewController = MainMapViewController()
        viewController.modalPresentationStyle = .fullScreen
//        viewController.modalTransitionStyle = .crossDissolve
        
        UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: false, completion: nil)
    }
}
