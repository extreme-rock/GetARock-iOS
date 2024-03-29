//
//  MemberSearchNetworkManager.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/03/25.
//

import Foundation

final class MemberSearchNetworkManager {
    func getSearchedMemberList(with memberName: String) async throws -> [SearchedUserInfo] {
        var result = SearchedUserListTempDTO(memberList: [])
        let baseURL = "https://api.ryomyom.com/member/search"
        var queryURLComponent = URLComponents(string: baseURL)
        let nameQuery = URLQueryItem(name: "memberName", value: memberName)
        let bandIdQuery = URLQueryItem(name: "bandId", value: "0")
        queryURLComponent?.queryItems = [nameQuery, bandIdQuery]
        guard let url = queryURLComponent?.url else { throw NetworkError.badURL }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            let httpResponse = response as! HTTPURLResponse

            if (200..<300).contains(httpResponse.statusCode) {
                print("Success \(httpResponse.statusCode)")
                let decodedData = try JSONDecoder().decode(SearchedUserListTempDTO.self, from: data)
                result = decodedData
                print(result)

            } else {
                throw NetworkError.failedRequest(status: httpResponse.statusCode)
            }
        } catch {
            print(error)
        }

        return result.memberList.map { data in
            SearchedUserInfo(memberId: data.memberId,
                             name: data.name,
                             memberState: data.memberState,
                             instrumentList: data.instrumentList,
                             gender: data.gender,
                             age: data.age)
        }
    }
}
