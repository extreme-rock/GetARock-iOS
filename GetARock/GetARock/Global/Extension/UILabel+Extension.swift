//
//  UILabel+Extension.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/22.
//

import UIKit

extension UILabel {
    func addLabelSpacing(kernValue: Double = 0, lineSpacing: CGFloat = 4.0) {
        if let labelText = self.text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedText = NSAttributedString(string: labelText,
                                                attributes: [.kern: kernValue,
                                                             .paragraphStyle: paragraphStyle])
            lineBreakStrategy = .hangulWordPriority
        }
    }
}
