//
//  Position.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import Foundation

struct Position: Hashable {
    let id = UUID()
    let instrumentName: String
    let instrumentImageName: Instrument
    let isETC: Bool
}
