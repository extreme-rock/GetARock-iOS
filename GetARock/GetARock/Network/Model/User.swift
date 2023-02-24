//
//  Member.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/24.
//

import Foundation

struct User: Codable {
    let memberId: String?
    let name: String
    let age: String
    let gender: String
    let introduction: String?
    let instrumentList: [InstrumentList]
    let snsList: [SnsList]?
}

