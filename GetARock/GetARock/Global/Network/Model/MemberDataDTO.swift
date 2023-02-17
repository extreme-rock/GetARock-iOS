//
//  MemberDataDTO.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import Foundation

struct MemberDataDTO: Codable {
    let memberList: [MemberList2]
}

//struct MemberList: Codable {
//    let memberId: Int?
//    let name: String
//    let memberState: MemberState
//    let instrumentList: [InstrumentList]
//}

struct MemberList2: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    let memberId: Int
    let name, memberState: String
    var instrumentList: [InstrumentList2]
    let gender: String
    let age: String
}

//struct InstrumentList: Codable {
//    let name: String
//}

struct InstrumentList2: Hashable, Codable {
    let instrumentId: Int
    let isMain: Bool
    let name: String
}

#if DEBUG
extension MemberDataDTO {
    static var testData =
        MemberDataDTO(memberList: [
            MemberList2(memberId: 0,
                       name: "루키",
                       memberState: "ADMIN",
                        instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "drum"), InstrumentList2(instrumentId: 0, isMain: false, name: "guitar")],
                       gender: "MEN",
                       age: "TWENITES"),
            MemberList2(memberId: 0,
                       name: "구엘",
                       memberState: "NONE",
                       instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            MemberList2(memberId: 0,
                       name: "노엘",
                       memberState: "NONE",
                       instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            MemberList2(memberId: 0,
                       name: "알로라",
                       memberState: "MEMBER",
                       instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "bass"), InstrumentList2(instrumentId: 0, isMain: false, name: "drum")],
                        gender: "WOMEN",
                        age: "TWENITES"),
            MemberList2(memberId: 0,
                       name: "데이크",
                       memberState: "MEMBER",
                       instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "bass")],
                        gender: "MEN",
                        age: "TWENITES"),
            MemberList2(memberId: 0,
                       name: "쏘시지불나방전기뱀장어",
                       memberState: "NONE",
                       instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: "vocal")],
                        gender: "MEN",
                        age: "TWENITES"),])

}
#endif

//extension CellInformation {
//    static var data = [
//        CellInformation(nickName: "구엘", instrument: "드럼"),
//        CellInformation(nickName: "루키", instrument: "베이스"),
//        CellInformation(nickName: "노엘", instrument: "기타"),
//        CellInformation(nickName: "데이크", instrument: "보컬"),
//        CellInformation(nickName: "알로라", instrument: "신디사이저"),
//        CellInformation(nickName: "가즈윌", instrument: "바이올린"),
//        CellInformation(nickName: "쏘시지불나방전기뱀장어", instrument: "바이올린")
//    ]
//}

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}


