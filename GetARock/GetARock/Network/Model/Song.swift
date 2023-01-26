//
//  song.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/26.
//

import Foundation

struct Song: Hashable {
    let id = UUID()
    let title: String
    let artist: String
    let link: String?
}
