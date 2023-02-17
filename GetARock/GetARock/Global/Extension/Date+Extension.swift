//
//  Date+Extension.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/17.
//

import Foundation

extension Date {
    
    // MARK: Date -> String로 변환
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
