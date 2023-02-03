//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

final class SNSListStackView: UIStackView {
    
    // MARK: - VIew
    
    private let bandIndex: Int
    private lazy var youtubeButton = SNSButtonView(type: .youtube, bandIndex: bandIndex)
    private lazy var instagramButton = SNSButtonView(type: .instagram, bandIndex: bandIndex)
    private lazy var soundCloudButton = SNSButtonView(type: .soundCloud, bandIndex: bandIndex)

    
    // MARK: - Init
    
    init(bandIndex: Int) {
        self.bandIndex = bandIndex
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
