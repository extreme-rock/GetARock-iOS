//
//  MemberDataDTO.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import Foundation

struct SearchedUserListDTO: Codable {
    let memberList: [SearchedUserInfo]
}
//MARK: 이름 기반 유저 검색시 받게되는 MemberList와 밴드 생성시 사용하는 MemberList의 내부 프로퍼티가 다르기 때문에 다른 이름을 사용

struct SearchedUserInfo: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    let memberId: Int
    let name: String
    let memberState: MemberState
    var instrumentList: [SearchedUserInstrumentList]
    //TODO: gender 및 age 정보 enum 만들기 
    let gender: String
    let age: String
}

struct SearchedUserInstrumentList: Hashable, Codable {
    let instrumentId: Int
    let isMain: Bool
    let name: String
}

#if DEBUG
extension SearchedUserListDTO {
    static var testData =
        SearchedUserListDTO(memberList: [
            SearchedUserInfo(memberId: 0,
                       name: "루키",
                             memberState: .admin,
                        instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "drum"), SearchedUserInstrumentList(instrumentId: 0, isMain: false, name: "guitar")],
                       gender: "MEN",
                       age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "구엘",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "노엘",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "알로라",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass"), SearchedUserInstrumentList(instrumentId: 0, isMain: false, name: "drum")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "데이크",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "쏘시지불나방전기뱀장어",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "MEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "루키2",
                             memberState: .admin,
                        instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "drum"), SearchedUserInstrumentList(instrumentId: 0, isMain: false, name: "guitar")],
                       gender: "MEN",
                       age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "구엘2",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "노엘2",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "알로라2",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass"), SearchedUserInstrumentList(instrumentId: 0, isMain: false, name: "drum")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "데이크2",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            SearchedUserInfo(memberId: 0,
                       name: "쏘시지불나방전기뱀장어2",
                             memberState: .none,
                       instrumentList: [SearchedUserInstrumentList(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "MEN",
                        age: "TWENITES")])

}
#endif
