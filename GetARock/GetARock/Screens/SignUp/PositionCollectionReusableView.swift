//
//  PositionCollectionReusableView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

final class PositionCollectionReusableView: UICollectionReusableView {
    
    func setupLayout(view: UIView) {
        self.addSubview(view)
        view.constraint(to: self)
    }
}

