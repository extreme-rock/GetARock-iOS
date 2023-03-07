//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

final class SNSListStackView: UIStackView {
    
    // MARK: - VIew
    
    private let snsData: SNS
    private lazy var youtubeButton = SNSButtonView(type: .youtube, data: snsData.youtube)
    private lazy var instagramButton = SNSButtonView(type: .instagram, data: snsData.instagram)
    private lazy var soundCloudButton = SNSButtonView(type: .soundCloud, data: snsData.soundCloud)
    
    // MARK: - Init
    
    init(data: SNS) {
        self.snsData = data
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func attribute() {
        self.axis = .horizontal
        self.spacing = 5
        self.distribution = .fillEqually
        self.constraint(.widthAnchor, constant: BasicComponentSize.width)
    }
    
    private func setupLayout() {
        self.addArrangedSubview(youtubeButton)
        self.addArrangedSubview(instagramButton)
        self.addArrangedSubview(soundCloudButton)

    }
}
