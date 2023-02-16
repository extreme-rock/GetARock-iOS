//
//  SNS.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import Foundation

struct SNS {
    let youtube: String?
    let instagram: String?
    let soundCloud: String?
}

enum SnsType: String, Codable {
    case youtube = "YOUTUBE"
    case instagram = "INSTAGRAM"
    case soundcloud = "SOUNDCLOUD"
}
