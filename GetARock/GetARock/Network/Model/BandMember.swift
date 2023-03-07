//
//  BandMember.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import Foundation

struct BandMember: Hashable {
    let id = UUID()
    var isUser: Bool
    var isLeader: Bool
    let userName: String
    var instrumentImageName: InstrumentImageName
    var instrumentNames: [String]
}
