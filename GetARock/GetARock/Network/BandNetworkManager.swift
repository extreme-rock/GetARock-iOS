//
//  BandNetworkManager.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/23.
//

import Foundation

final class BandNetworkManager {
    static let shared = BandNetworkManager()
    
    func deleteBand(with bandID: Int) throws {
        let baseURL = "https://api.ryomyom.com/band"
        var queryURLComponent = URLComponents(string: baseURL)
        let bandIdQuery = URLQueryItem(name: "id", value: String(bandID))
        queryURLComponent?.queryItems = [bandIdQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
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
