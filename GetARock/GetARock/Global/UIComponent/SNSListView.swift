//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

class SNSListView: UIView {
    
    // MARK: - VIew
    
    private let youtubeButton: SNSButtonView = {
        return $0
    }(SNSButtonView(type: .youtube))
    
    private let instagramButton: SNSButtonView = {
        return $0
    }(SNSButtonView(type: .instagram))
    
    private let soundCloudButton: SNSButtonView = {
        return $0
    }(SNSButtonView(type: .soundCloud))
    
    private lazy var snsListStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [youtubeButton, instagramButton, soundCloudButton]))
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        self.addSubview(snsListStackView)
        self.snsListStackView.constraint(.widthAnchor, constant: UIScreen.main.bounds.width - 32)
    }
}
