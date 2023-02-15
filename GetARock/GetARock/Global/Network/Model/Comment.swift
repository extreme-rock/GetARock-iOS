//
//  Comment.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import Foundation

struct CommentList: Codable {
    let commentID: Int
    let memberName, comment, createdDate: String
}
