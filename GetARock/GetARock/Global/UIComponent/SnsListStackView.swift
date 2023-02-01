//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

final class SnsListStackView: UIStackView {
    
    // MARK: - VIew
    
    private let youtubeButton = SnsButtonView(type: .youtube)
    private let instagramButton = SnsButtonView(type: .instagram)
    private let soundCloudButton: SnsButtonView = SnsButtonView(type: .soundCloud)
    
    // MARK: - Init
    
    init() {
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
