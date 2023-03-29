//
//  BandCreationNetworkManager.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/22.
//

import Foundation

final class BandInformationNetworkManager {

    func getBandData(bandId: Int) async throws -> BandInformationVO {
        var result: BandInformationVO = BandInformationVO(bandID: 0,
                                                          name: "",
                                                          age: "",
                                                          introduction: "",
                                                          address: AddressVO(city: "", street: "", detail: "", longitude: 0, latitude: 0),
                                                          memberList: [],
                                                          songList: [],
                                                          snsList: [],
                                                          eventList: [],
                                                          commentList: [])
        let baseURL = "https://api.ryomyom.com/band"
        var queryURLComponent = URLComponents(string: baseURL)
        let nameQuery = URLQueryItem(name: "id", value: String(describing: bandId))
        queryURLComponent?.queryItems = [nameQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse

            if (200..<300).contains(httpResponse.statusCode) {
                let decodedData = try JSONDecoder().decode(BandInformationVO.self, from: data)
                result = decodedData

            } else {
                throw NetworkError.failedRequest(status: httpResponse.statusCode)
            }
            print(httpResponse)
        } catch {
            print(error)
        }

        return result
    }
    
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
            print("+++=======++++")
            print(data.memberList)
            print(data.memberList.count)
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

    func putModifiedBandMemberInformation(data: BandPUTDTO) async throws {
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


