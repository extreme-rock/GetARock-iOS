//
//  NetworkManager.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/23.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getNotificationList(memberId: Int) async throws -> [NotificationInfo] {
        var returnData: [NotificationInfo] = []
        var baseURL = "https://api.ryomyom.com/alerts"
        
        var queryURLComponent = URLComponents(string: baseURL)
        let memberIdQuery = URLQueryItem(name: "memberId", value: String(memberId))
        queryURLComponent?.queryItems = [memberIdQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse
            
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
}
