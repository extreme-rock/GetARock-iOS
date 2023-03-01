//
//  NetworkManager.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/23.
//

import UIKit

final class NotificationNetworkManager {
    
    static let shared = NotificationNetworkManager()
    
    func getNotificationList(memberId: Int) async throws -> [NotificationInfo] {
        var returnData: [NotificationInfo] = []
        let baseURL = "https://api.ryomyom.com/alerts"
        
        var queryURLComponent = URLComponents(string: baseURL)
        let memberIdQuery = URLQueryItem(name: "memberId", value: String(memberId))
        queryURLComponent?.queryItems = [memberIdQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else { return [] }
            
            if (200..<300).contains(httpResponse.statusCode) {
                let decodedData = try JSONDecoder().decode([NotificationInfo].self, from: data)
                returnData = decodedData
            } else {
                throw NetworkError.failedRequest(status: httpResponse.statusCode)
            }
            print(httpResponse)
        } catch {
            print(error)
        }
        return returnData
    }
    
    func acceptInvitation() {
        
    }
    
    func rejectInvitation(alertId: Int, bandId: Int, memberId: Int) {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        let baseURL = "https://api.ryomyom.com/alert/invitation/deny"
        var queryURLComponent = URLComponents(string: baseURL)
        let alertIdQuery = URLQueryItem(name: "alertId", value: String(alertId))
        let bandIdQuery = URLQueryItem(name: "bandId", value: String(bandId))
        let memberIdQuery = URLQueryItem(name: "memberId", value: String(memberId))
        
        queryURLComponent?.queryItems = [alertIdQuery, bandIdQuery, memberIdQuery]
        guard let url = queryURLComponent?.url else {
            print(NetworkError.badURL.errorDescription ?? "")
            return
        } // UIAction 클로저로 throw 형태를 받을 수 없어서 프린트문으로 대체함
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case (200...299):
                    print("success")
                    print(httpResponse)
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
