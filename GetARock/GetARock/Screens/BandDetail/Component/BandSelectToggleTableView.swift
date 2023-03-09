//
//  BandSelectToggleView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/09.
//

import UIKit

final class BandSelectToggleTableView: UIView {
// 밴드 이름을 전달 받음,
    // 해당 이름이 눌리면 delegate로 바로 넣으면 될듯 bandDetailView에
    // MARK: - Property
    private let bandNames: [String]
    // MARK: - View
    
    // MARK: - Init
    
    init(bandNames: [String]) {
        self.bandNames = bandNames
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
}
