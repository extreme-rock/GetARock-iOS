//
//  SignUpNetworkManager.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/24.
//

import Foundation

final class SignUpNetworkManager {
    static func postMember(user: User) {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        guard let url = URL(string: "https://api.ryomyom.com/member") else { return }
        var request = URLRequest(url: url)
        var encodedData = Data()
        
        do {
            let data = try JSONEncoder().encode(user)
            encodedData = data
            print(encodedData)
        } catch {
            print("Data Encoding Error")
        }
        
        request.httpMethod = "POST"
        request.httpBody = encodedData
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print("Network Error in dataTask")
            } else {
                print(response, "response")
                do {
                    let result = try JSONDecoder().decode(SignUpResult.self, from: data!)
                    print(result)
                } catch {
                    print("dcode error")
                }
                
            }
        }
        dataTask.resume()
    }
}

struct SignUpResult: Codable {
    let id: Int?
    let success: Bool
}

