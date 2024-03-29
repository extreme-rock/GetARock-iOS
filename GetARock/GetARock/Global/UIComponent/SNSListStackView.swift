//
//  SNSListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/31.
//

import UIKit
    
final class SNSListStackView: UIStackView {
    
    // MARK: - View
    
    private var snsData: SNS?
    private lazy var youtubeButton = SNSButtonView(type: .youtube, data: snsData?.youtube)
    private lazy var instagramButton = SNSButtonView(type: .instagram, data: snsData?.instagram)
    private lazy var soundCloudButton = SNSButtonView(type: .soundCloud, data: snsData?.soundCloud)

    // MARK: - Init
    
    init(data: [SnsListVO]) {
        super.init(frame: .zero)
        self.snsData = self.toSNS(with: data)
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
    
    private func toSNS(with snsList: [SnsListVO]) -> SNS? {
        let links = Dictionary(uniqueKeysWithValues: snsList.map { ($0.snsType, $0.link)})
        
        guard let youtubeLink = links[.youtube],
              let instagramLink = links[.instagram],
              let soundCloudLink = links[.soundcloud] else { return nil }
        
        let sns = SNS(youtube: youtubeLink,
                      instagram: instagramLink,
                      soundCloud: soundCloudLink)
        return sns
    }
    
    func configureSNSList(with data: [SnsListVO]) {
        let sns = toSNS(with: data)
        self.youtubeButton.configureSNSAttribute(with: sns?.youtube)
        self.instagramButton.configureSNSAttribute(with: sns?.instagram)
        self.soundCloudButton.configureSNSAttribute(with: sns?.soundCloud)
    }
}
