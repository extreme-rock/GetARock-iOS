//
//  NetworkManager.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/23.
//

import UIKit

//TODO: 추후 프린트문 error handling case 체크 필요
final class NotificationNetworkManager {
    
    static let shared = NotificationNetworkManager()
    
    func getNotificationList(memberID: Int) async throws -> NotificationListVO {
        var returnData: NotificationListVO = NotificationListVO(alertList: [])
        let baseURL = "https://api.ryomyom.com/alerts"
        
        var queryURLComponent = URLComponents(string: baseURL)
        let memberIdQuery = URLQueryItem(name: "memberId", value: String(memberID))
        queryURLComponent?.queryItems = [memberIdQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else { return NotificationListVO(alertList: []) }
            
            if (200..<300).contains(httpResponse.statusCode) {
                let decodedData = try JSONDecoder().decode(NotificationListVO.self, from: data)
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
    
    func acceptInvitation(alertId: Int, bandId: Int, memberId: Int, memberInstrument: [String], completion: @escaping ()->Void) {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        let baseURL = "https://api.ryomyom.com/alert/invitation/agree"
        var queryURLComponent = URLComponents(string: baseURL)
        
        let alertIdQuery = URLQueryItem(name: "alertId", value: String(alertId))
        let bandIdQuery = URLQueryItem(name: "bandId", value: String(bandId))
        let memberIdQuery = URLQueryItem(name: "memberId", value: String(memberId))
        let instrumentQuery = URLQueryItem(name: "memberInstrument", value: memberInstrument.joined(separator: ","))
        
        queryURLComponent?.queryItems = [alertIdQuery, bandIdQuery, memberIdQuery, instrumentQuery]
        guard let url = queryURLComponent?.url else {
            print(NetworkError.badURL.errorDescription ?? "")
            return }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case (200...299):
                    print("success")
                    print(httpResponse)
                    DispatchQueue.main.async { completion() } // completion 클로저가 UI 관련 코드를 포함함
                case (300...599):
                    print(NetworkError.failedRequest(status: httpResponse.statusCode))
                default:
                    print("unknown")
                }
            }
        }
        dataTask.resume()
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
            return }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
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
