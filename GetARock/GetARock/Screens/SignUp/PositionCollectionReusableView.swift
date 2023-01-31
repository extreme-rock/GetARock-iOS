//
//  PositionCollectionReusableView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

class PositionCollectionReusableView: UICollectionReusableView {
    
    private let pageIndicatorLabel: UILabel = {
        $0.font = .setFont(.subTitle)
        $0.text = "1/3"
        $0.textColor = .gray02
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    
    private let titleLabel: UILabel = {
        $0.font = .setFont(.largeTitle01)
        $0.text = "할 수 있는 포지션을\n모두 알려주세요"
        $0.textColor = .white
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = .setFont(.subTitle)
        $0.text = "처음 선택한 악기가\n나의 Main 포지션이 됩니다."
        $0.textColor = .gray02
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
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
