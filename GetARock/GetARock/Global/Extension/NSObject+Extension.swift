//
//  NSObject+Extension.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
