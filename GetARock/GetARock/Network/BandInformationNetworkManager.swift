//
//  BandCreationNetworkManager.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/22.
//

import Foundation

final class BandInformationNetworkManager {
    
    func postBandCreation(data: BandCreationDTO) async throws {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        
        guard let url = URL(string: "https://api.ryomyom.com/band") else { throw NetworkError.badURL }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        var encodedData = Data()
        
        do {
            let data = try JSONEncoder().encode(data)
            encodedData = data
        } catch {
            throw NetworkError.badJSON(error: error)
        }
        
        request.httpMethod = "POST"
        request.httpBody = encodedData
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
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

    func putModifiedBandMemberInformation(data: BandCreationDTO) async throws {
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]

        guard let url = URL(string: "https://api.ryomyom.com/band") else { throw NetworkError.badURL }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10)
        var encodedData = Data()

        do {
            let data = try JSONEncoder().encode(data)
            encodedData = data
        } catch {
            throw NetworkError.badJSON(error: error)
        }

        request.httpMethod = "PUT"
        request.httpBody = encodedData
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
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


