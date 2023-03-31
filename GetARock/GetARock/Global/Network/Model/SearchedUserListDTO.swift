//
//  MemberDataDTO.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import Foundation

struct SearchedUserListDTO: Codable {
    var memberList: [SearchedUserInfo]
}
//MARK: 이름 기반 유저 검색시 받게되는 MemberList와 밴드 생성시 사용하는 MemberList의 내부 프로퍼티가 다르기 때문에 다른 이름을 사용

struct SearchedUserInfo: Hashable, Codable, Identifiable {
    var id: String = UUID().uuidString
    let memberId: Int?
    let name: String
    var memberState: MemberState
    var instrumentList: [SearchedUserInstrumentList]
    let gender: String
    let age: String
}

struct SearchedUserInstrumentList: Hashable, Codable {
    let instrumentId: Int?
    let isMain: Bool
    let name: String
}

#if DEBUG
extension SearchedUserListDTO {
    static var dataSet =
    SearchedUserListDTO(memberList: [])
}
#endif


struct SearchedUserListTempDTO: Codable {
    let memberList: [SearchedUserInfoVO]
}

struct SearchedUserInfoVO: Hashable, Codable{
    let memberId: Int
    let name: String
    var memberState: MemberState
    var instrumentList: [SearchedUserInstrumentList]
    let gender: String
    let age: String
}
