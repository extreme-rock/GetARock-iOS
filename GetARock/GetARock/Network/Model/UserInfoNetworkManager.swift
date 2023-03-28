//
//  UserInfoNetworkManger.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/03/28.
//

import Foundation

final class UserInfoNetworkManager {
    static let shared = UserInfoNetworkManager()

    func fetchUserData(with memberID: Int) async -> UserInformationVO? {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/member")
        let idQuery = URLQueryItem(name: "id", value: String(memberID))
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(UserInformationVO.self, from: data)
            print("Response data raw : \(data)")
            print("응답 내용 : \(response)")
//            self.userData = decodedData
            return decodedData
        } catch {
            print(error)
            print("bad news! decoding error occuerd")
        }
        return nil
    }
}
