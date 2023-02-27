//
//  NotificationListDTO.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import Foundation

// MARK: - AlertData
struct NotificationListVO: Codable {
    let alertList: [NotificationInfo]
}

// MARK: - AlertList
struct NotificationInfo: Codable {
    let alertID: Int
    let isInvitation: Bool
    let alertType, title: String
    let content: String
    let isChecked: Bool
    let updatedDate: String
    let bandID, eventID: Int

    enum CodingKeys: String, CodingKey {
        case alertID = "alertId"
        case isInvitation, alertType, title, content, isChecked, updatedDate
        case bandID = "bandId"
        case eventID = "eventId"
    }
}

extension NotificationListVO {
    static var testData: [NotificationInfo] = [
        NotificationInfo(alertID: 0, isInvitation: true, alertType: "", title: "새로운 밴드 초대 💌", content: "00밴드로부터 초대장이 왔어요", isChecked: false, updatedDate: "2023-02-23 13:33", bandID: 1, eventID: -1),
        NotificationInfo(alertID: 0, isInvitation: false, alertType: "", title: "‘블랙로즈' 방명록 🦹", content: "밴드 ‘블랙로즈'에 새로운 방명록이 달렸어요!", isChecked: false, updatedDate: "2023-02-23 11:33", bandID: 1, eventID: -1),
        NotificationInfo(alertID: 0, isInvitation: false, alertType: "", title: "블랙로즈' 모여락 🤘", content: "연말공연 같이할 팀 구해요 어쩌...’ 모여락에 새로운 댓글이 달렸어요!", isChecked: false, updatedDate: "2023-02-22 13:33", bandID: -1, eventID: 1),
        NotificationInfo(alertID: 0, isInvitation: false, alertType: "", title: "내가 댓글 남긴 모여락 🤘", content: "안녕하세요 여러분 모여락....’ 모여락에 새로운 댓글이 달렸어요!", isChecked: false, updatedDate: "2023-02-20 13:33", bandID: -1, eventID: 1),
        NotificationInfo(alertID: 0, isInvitation: false, alertType: "", title: "밴드 권한 변경 👑️" , content: "밴드 ‘로젤리아'의 리더로 임명되었어요!", isChecked: false, updatedDate: "2023-02-17 13:33", bandID: 1, eventID: 0)
    ]
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

