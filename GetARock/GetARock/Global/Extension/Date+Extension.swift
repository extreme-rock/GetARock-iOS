//
//  Date+Extension.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//
//
import Foundation
//
extension Date {
    var abbreviatedRelativeKRTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
