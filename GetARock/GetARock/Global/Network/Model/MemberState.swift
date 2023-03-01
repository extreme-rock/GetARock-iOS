//
//  MemberState.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/14.
//

enum MemberState: String, Codable {
    case admin = "ADMIN"
    case inviting = "INVITING"
    case member = "MEMBER"
    case approved = "APPROVE"
    case denied = "DENY"
    case annonymous = "ANNONYMOUS"
}
