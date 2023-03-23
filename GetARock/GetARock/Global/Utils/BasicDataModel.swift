//
//  ModelData.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/13.
//

struct BasicDataModel {
    static var bandCreationData: BandCreationDTO = BandCreationDTO(
        name: "user",
        address: Address(city: "default",
                         street: "default",
                         detail: "default",
                         longitude: 0.0,
                         latitude: 0.0),

        songList: nil,

        memberList: [],
        introduction: nil,

        snsList: nil
    )
    
    static let dummyBandInfo = BandInformationVO(
        bandID: 0,
        name: "모여락 밴드",
        age: "20대",
        introduction: "안녕하세요 투플러스쓰리입니다. 저희밴드는 [여2+남3] / MBTI [E2 + I3], [S2 + N3], [F2+T3], [P2 + J3] 로 이루어져 있습니다.",
        address: AddressVO(city: "포항",
                           street: "지곡로",
                           detail: "씨팦",
                           longitude: 30.0,
                           latitude: 30.0),
        memberList: [MemberListVO(memberBandID: 0,
                                  memberID: 1,
                                  name: "구엘",
                                  memberState: .admin,
                                  instrumentList: [InstrumentListVO(instrumentID: 0,
                                                                    isMain: true,
                                                                    name: "drum"),
                                                   InstrumentListVO(instrumentID: 1,
                                                                    isMain: false,
                                                                    name: "vocal")]),
                     MemberListVO(memberBandID: 0,
                                  memberID: 2,
                                  name: "알로라",
                                  memberState: .inviting,
                                  instrumentList: [InstrumentListVO(instrumentID: 0,
                                                                    isMain: true,
                                                                    name: "piano"),
                                                   InstrumentListVO(instrumentID: 1,
                                                                    isMain: false,
                                                                    name: "vocal")]),
                     MemberListVO(memberBandID: 0,
                                  memberID: 3,
                                  name: "노엘",
                                  memberState: .none,
                                  instrumentList: [InstrumentListVO(instrumentID: 0,
                                                                    isMain: true,
                                                                    name: "guitar"),
                                                   InstrumentListVO(instrumentID: 1,
                                                                    isMain: false,
                                                                    name: "vocal")]),
                     MemberListVO(memberBandID: 0,
                                  memberID: 5,
                                  name: "데이크",
                                  memberState: .annonymous,
                                  instrumentList: [InstrumentListVO(instrumentID: 0,
                                                                    isMain: true,
                                                                    name: "drum"),
                                                   InstrumentListVO(instrumentID: 1,
                                                                    isMain: false,
                                                                    name: "vocal")]),
                     MemberListVO(memberBandID: 0,
                                  memberID: 6,
                                  name: "한스",
                                  memberState: .inviting,
                                  instrumentList: [InstrumentListVO(instrumentID: 0,
                                                                    isMain: true,
                                                                    name: "guitar"),
                                                   InstrumentListVO(instrumentID: 1,
                                                                    isMain: false,
                                                                    name: "vocal")]),
                     
        ],
        
        songList: [SongListVO(songID: 0, name: "흔들리는 꽃들속에서 네 샴푸향이", artist: "장범준", link: ""),
                   SongListVO(songID: 0, name: "Hysteria", artist: "MUSE", link: "")],
        snsList: [SnsListVO(snsID: 0,
                            snsType: .instagram,
                            link: ""),
                  SnsListVO(snsID: 0,
                            snsType: .youtube,
                            link: ""),],
        eventList: [EventList(eventID: 0,
                              name: "첫 공연이에요",
                              eventDate: "2023-09-01",
                              eventState: .open)],
        commentList: [CommentList(commentID: 0,
                                  memberName: "루키",
                                  comment: "안녕하세요 저희밴드와 교류하실래여?",
                                  createdDate: "2023-09-01")])
}

