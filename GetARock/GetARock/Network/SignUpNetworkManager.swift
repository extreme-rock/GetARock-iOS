//
//  SignUpNetworkManager.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/24.
//

import Foundation

struct SignUpVO: Decodable {
    let id: Int
    let success: Bool
}

final class SignUpNetworkManager {
    
    static let shared = SignUpNetworkManager()
    
   func postUserInformation(user: User) async throws {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "social-token": "\(UserDefaultStorage.identityToken)"
        ]
       print(UserDefaultStorage.identityToken, "identityTokenmember")
        guard let url = URL(string: "https://api.ryomyom.com/member") else { throw NetworkError.badURL }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        var encodedData = Data()
        
        do {
            let data = try JSONEncoder().encode(user)
            encodedData = data
        } catch {
            throw NetworkError.badJSON(error: error)
        }
        
        request.httpMethod = "POST"
        request.httpBody = encodedData
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case (200...299):
                    print("success")
                    //TODO: 받아온 id를 userDefault에 넣어야함
                    do {
                        let decodedData = try JSONDecoder().decode(SignUpVO.self, from: data!)
                        UserDefaultHandler.setMemberID(memberID: decodedData.id)
                        UserDefaultHandler.setIsLogin(isLogin: true)
                        Task {
                            let userInfo = await UserInfoNetworkManager.shared.fetchUserData(with: decodedData.id)
                            UserDefaultHandler.setUserName(name: userInfo?.name ?? "")
                        }
                    } catch {
                        print(error)
                    }
                case (300...599):
                    print(NetworkError.failedRequest(status: httpResponse.statusCode))
                default:
                    print("unknown")
                }
            }
        }
        dataTask.resume()
    }
    
   func putUserInformation(user: User, completion: @escaping((Result<Bool, Error>) -> Void)) async throws {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        guard let url = URL(string: "https://api.ryomyom.com/member") else { throw NetworkError.badURL }
        var request = URLRequest(url: url)
        var encodedData = Data()
        
        do {
            let data = try JSONEncoder().encode(user)
            encodedData = data
        } catch {
            throw NetworkError.badJSON(error: error)
        }
        
        request.httpMethod = "PUT"
        request.httpBody = encodedData
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(NetworkError.badResponse.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case (200...299):
                    do {
                        let decodedData = try JSONDecoder().decode(SignUpVO.self, from: data!)
                        Task {
                            let userInfo = await UserInfoNetworkManager.shared.fetchUserData(with: decodedData.id)
                            UserDefaultHandler.setUserName(name: userInfo?.name ?? "")
                        }
                    } catch {
                        print(error)
                    }
                    completion(.success(true))
                case (300...599):
                    completion(.failure(NetworkError.failedRequest(status: httpResponse.statusCode)))
                default:
                    completion(.failure(NetworkError.unknown))
                }
            }
        }
        dataTask.resume()
    }
}
