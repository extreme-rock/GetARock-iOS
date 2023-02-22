//
//  LeaderPositionSelectHeaderView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

final class LeaderPositionSelectHeaderView: UIView {
    
    private let pageIndicatorLabel = BasicLabel(contentText: "1/3", fontStyle: .headline03, textColorInfo: .gray02)
    
    //TODO: 추후 유저 데이터를 이용해 이름을 유저에 맞게 업데이트해야함
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "루키님은 밴드에서\n어떤 포지션인가요?", fontStyle: .largeTitle01, textColorInfo: .white))
    
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
                                      padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        self.addSubview(titleLabel)
        titleLabel.constraint(top: pageIndicatorLabel.bottomAnchor,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0))
        
        self.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 0, bottom: 49, right: 0))
    }
}
