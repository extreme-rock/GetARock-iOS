//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit

class SNSListView: UIView {
    
    // MARK: - Property
    
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
    
    private lazy var SnsListStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
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
           self.addSubview(SnsListStackView)
           self.SnsListStackView.constraint(.widthAnchor, constant:  UIScreen.main.bounds.width * 0.9)
           self.SnsListStackView.constraint(.heightAnchor, constant: 75)
       }
}
