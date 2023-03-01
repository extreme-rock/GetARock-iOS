import Foundation

// MARK: - BandInformationVO
struct BandInformationVO: Codable {
    let bandID: Int
    let name, age: String
    let introduction: String? // 정보 입력시 선택사항
    let address: AddressVO
    let memberList: [MemberListVO]
    let songList: [SongListVO]? // 정보 입력시 선택사항
    let snsList: [SnsListVO]? // 정보 입력시 선택사항
    let eventList: [EventList]? // 없을 수 있음
    let commentList: [CommentList]? // 없을 수 있음
    enum CodingKeys: String, CodingKey {
        case bandID = "bandId"
        case name, introduction, age, address, memberList, songList, snsList, eventList
        case commentList = "comment_list"
    }
}

// MARK: - Address
struct AddressVO: Codable {
    let city, street, detail: String
    let longitude, latitude: Double
}

// MARK: - CommentList
struct CommentList: Codable {
    let commentID: Int
    let memberName, comment, createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case memberName, comment, createdDate
    }
}

// MARK: - EventList
struct EventList: Codable {
    let eventID: Int
    let name, eventDate: String
    let eventState: EventState
    
    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case eventState, name, eventDate
    }
}

// MARK: - MemberList
struct MemberListVO: Codable, Hashable, Identifiable {
    let id: String = UUID().uuidString
    let memberBandID: Int?
    let memberID: Int?
    let name: String
    let memberState: MemberState
    let instrumentList: [InstrumentListVO]
    
    enum CodingKeys: String, CodingKey {
        case memberBandID = "memberBandId"
        case memberID = "memberId"
        case name, memberState, instrumentList
    }
}

// MARK: - InstrumentList
struct InstrumentListVO: Codable, Hashable {
    let instrumentID: Int?
    let isMain: Bool?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case instrumentID = "instrumentId"
        case isMain, name
    }
}

// MARK: - SnsList
struct SnsListVO: Codable {
    let snsID: Int
    let snsType: SnsType
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case snsID = "snsId"
        case snsType, link
    }
}

// MARK: - SongList
struct SongListVO: Codable {
    let songID: Int? //입력시 선택항목
    let name, artist: String? //입력시 선택항목
    let link: String? //입력시 선택항목
    enum CodingKeys: String, CodingKey {
        case songID = "songId"
        case name, artist, link
    }
}
