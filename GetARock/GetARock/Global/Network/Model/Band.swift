//
//  Band.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/25.
//

import Foundation

struct Band {
    //    let bandID: UUID
    let name: String
    //    let age: String
    let location: Location
    //    let introduction: String?
    //    let member: [BandMember]
    var song: [Song]?
    var sns: SNS
    var commentList: [CommentList]?
}

struct BandDummyData {
    static var testBands: [Band] = [
        Band(name: "레드제플린", location: Location(
            name: "레드제플린",
            address: "대구광역시 남구 명덕로 102",
            additionalAddress: "레드제플린",
            coordinate: Coordinate(latitude: 35.85672, longitude: 128.58130)),
             song: [Song(title: "노엘갤러거는 최고다", artist: "오아시스", link: nil),
                    Song(title: "Champagne Supernova", artist: "OASIS", link: "https://youtu.be/tI-5uv4wryI"),
                    Song(title: "Little by Little", artist: "OASIS", link: "https://youtu.be/ic-Na--7_NI")],
             sns: SNS(youtube: "UCUDVBtnOQi4c7E8jebpjc9Q", instagram: nil, soundCloud: nil),
             commentList: [CommentList.init(commentID: 01,
                                            memberName: "블랙로즈",
                                            comment: "오 효자동 근처 밴드네요! 반갑습니당 >///< 저희도 근처에 있는데 꼭 공연보러갈게요!",
                                            createdDate: "2022.11.19 13:20"),
                           CommentList.init(commentID: 02,
                                            memberName: "오아시스",
                                            comment: "오 효자동 근처 밴드네요! 반갑습니당 >///< 저희도 근처에 있는데 꼭 공연보러갈게요!",
                                            createdDate: "2022.11.19 13:20"),
                           CommentList.init(commentID: 03,
                                            memberName: "3번쨰 밴드",
                                            comment: "오 효자동 근처 밴드네요! 반갑습니당 >///< 저희도 근처에 있는데 꼭 공연보러갈게요!",
                                            createdDate: "2022.11.19 13:20")]
        ),
                Band(name: "블랙로즈블랙로즈블랙", location: Location(
                    name: "블랙로즈",
                    address: "대한민국 대구광역시 중구 태평로2가 17-11",
                    additionalAddress: nil,
                    coordinate: Coordinate(latitude: 35.87478, longitude: 128.59192)),
                     sns: SNS(youtube: "UCUDVBtnOQi4c7E8jebpjc9Q",
                              instagram: "UCUDVBtnOQi4c7E8jebpjc9Q",
                              soundCloud: nil),
                     commentList: nil
                ),
                Band(name: "모닝샐러드", location: Location(
                    name: "모닝샐러드",
                    address: "대한민국 대구광역시 중구 남산동 2185-110",
                    additionalAddress: nil,
                    coordinate: Coordinate(latitude: 35.85785, longitude: 128.58661)),
                     sns: SNS(youtube: nil, instagram: nil, soundCloud: nil),
                     commentList: nil),
    ]
}
