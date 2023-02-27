//
//  UIView+Extension.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/20.
//

import UIKit

// MARK: - UIVIew 상단에 Border 추가

extension UIView {
    func addTopBorder(color: UIColor?, borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderWidth)
        self.addSubview(border)
    }
}
