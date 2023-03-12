//
//  BandMember.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import Foundation

struct BandMember: Hashable {
    let id = UUID()
    let isUser: Bool
    let isLeader: Bool
    let userName: String
    let instrumentImageName: Instrument
    let instrumentNames: [String]
}
