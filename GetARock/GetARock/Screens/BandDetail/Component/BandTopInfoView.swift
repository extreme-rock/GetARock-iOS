//
//  BandTopInfoView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandTopInfoView: UIView {

    // MARK: - View
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    private let bandNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "블랙로즈", fontStyle: .headline04, textColorInfo: .white))
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    private let locationLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "경북 포항시 남구 연일읍 동문로 40-1", fontStyle: .content, textColorInfo: .white))
    
    private let customPinIconImage: UIImageView = {
        $0.image = ImageLiteral.customPinIcon
        $0.constraint(.widthAnchor, constant: 12)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var locationStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [customPinIconImage,locationLabel]))
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel,locationStackView]))
    
    private let divider: UIView = {
        $0.backgroundColor = .dark02
        return $0
    }(UIView())
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }

    private func setupLayout() {
        self.addSubview(infoStackView)
        infoStackView.constraint(top: self.topAnchor,
                                 leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16))
        
        self.addSubview(divider)
        divider.constraint(top: infoStackView.bottomAnchor,
                            leading: self.leadingAnchor,
                            bottom: self.bottomAnchor ,
                            trailing: self.trailingAnchor,
                            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        self.divider.constraint(.heightAnchor, constant: DividerSize.height)
    }
}
