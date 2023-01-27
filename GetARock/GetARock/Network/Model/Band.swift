//
//  Band.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/26.
//

import Foundation

struct Band: Hashable {
    let id = UUID()
    let name: String
    var song: [Song]?
//    let bandMember: [BandMember] (데이크 pr)
//    let location: Location (로라 PR)
//    var sns: [SNS]?
//    let introduction: String?
//    let events: [Events]?
//    let comments: [Comments]?
//    let member: [BandMember]
//    var sns: [SNS]?
}

var testband: [Band] = [
    Band(name: "블랙로즈",
         song: [Song(title: "Don't Look Back in Anger", artist: "OASIS", link: nil),
                Song(title: "Champagne Supernova", artist: "OASIS", link: "https://youtu.be/tI-5uv4wryI"),
                Song(title: "Little by Little", artist: "OASIS", link: "https://youtu.be/ic-Na--7_NI")]),
    Band(name: "로젤리아",
         song: []),
    Band(name: "테스트밴드",
         song: [Song(title: "Don't Look Back in Anger", artist: "OASIS", link: nil),
                Song(title: "Champagne Supernova", artist: "OASIS", link: "https://youtu.be/tI-5uv4wryI")])
]
