//
//  DuplicationCheckRequest.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/01.
//
import Foundation

final class DuplicationCheckRequest {

    static func checkDuplication(checkCase: DuplicationCheckType, word: String) async throws -> Bool {
        var result = false
        var baseURL = ""
        switch checkCase {
        case .userName: baseURL = "https://api.ryomyom.com/member/validate"
        case .bandName: baseURL = "https://api.ryomyom.com/band/validate"
        case .none: return false
        }
        
        var queryURLComponent = URLComponents(string: baseURL)
        let nameQuery = URLQueryItem(name: "name", value: word)
        queryURLComponent?.queryItems = [nameQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as! HTTPURLResponse
            
            if (200..<300).contains(httpResponse.statusCode) {
                let decodedResponse = try JSONDecoder().decode(NameDuplicationCheckVO.self, from: data)
                result = decodedResponse.success
            } else {
                throw NetworkError.failedRequest(status: httpResponse.statusCode)
            }
            print(httpResponse)
        } catch {
            print(error)
        }
        
        return result
    }
}

