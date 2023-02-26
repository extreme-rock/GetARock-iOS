//
//  SignUpNetworkManager.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/24.
//

import Foundation

final class SignUpNetworkManager {
    static func postMember(user: User) async throws {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
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
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(NetworkError.badResponse.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case (200...299):
                    print("success")
                case (300...599):
                    print(NetworkError.failedRequest(status: httpResponse.statusCode))
                default:
                    print("unknown")
                }
            }
        }
        dataTask.resume()
    }
    
    static func putMember(user: User) async throws {
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
                    print("success")
                case (300...599):
                    print(NetworkError.failedRequest(status: httpResponse.statusCode))
                default:
                    print("unknown")
                }
            }
        }
        dataTask.resume()
    }
}
