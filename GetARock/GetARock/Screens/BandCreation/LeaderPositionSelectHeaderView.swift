//
//  LeaderPositionSelectHeaderView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

final class LeaderPositionSelectHeaderView: UIView {
    
    private let pageIndicatorLabel = BasicLabel(contentText: "1/3", fontStyle: .subTitle, textColorInfo: .gray02)
    
    //TODO: 추후 유저 데이터를 이용해 이름을 유저에 맞게 업데이트해야함
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: "00님의\n밴드에서포지션을\n알려주세요.", fontStyle: .largeTitle01, textColorInfo: .white))
    
    private let subTitleLabel: BasicLabel = BasicLabel(contentText: "최대 2개까지 선택 가능합니다.",
                                                       fontStyle: .subTitle,
                                                       textColorInfo: .gray02)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(pageIndicatorLabel)
        pageIndicatorLabel.constraint(top: self.topAnchor,
                                      leading: self.leadingAnchor,
                                      trailing: self.trailingAnchor,
                                      padding: UIEdgeInsets(top: 20, left: 17, bottom: 0, right: 0))
        
        self.addSubview(titleLabel)
        titleLabel.constraint(top: pageIndicatorLabel.bottomAnchor,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              padding: UIEdgeInsets(top: 6, left: 16, bottom: 0, right: 16))
        
        self.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 16, bottom: 49, right: 16))
    }
}