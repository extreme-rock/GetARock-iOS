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
    var abbreviatedRelativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
