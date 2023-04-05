//
//  GetARockInfoPopUpView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/02.
//

import UIKit

protocol GetARockInfoPopUpViewDelegate: AnyObject {
    func dismissButtonTapped()
    func makeBandButtonTapped()
}

final class GetARockInfoPopUpView: UIView {
    
    // MARK: - Property
    
    weak var delegate: GetARockInfoPopUpViewDelegate?
    
    // MARK: - View
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark03
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    private lazy var dismissButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        let action = UIAction { [weak self] _ in
            self?.delegate?.dismissButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))
    
    private let titleLabel = BasicLabel(contentText: "모여락 안내",
                                        fontStyle: .headline01,
                                        textColorInfo: .white)
    
    private let subTitleLabel: BasicLabel = {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        return $0
    }(BasicLabel(contentText: "모여락에서 밴드를 즐겁게!\n밴드를 만들면 아래와 같은 활동이 가능해요!",
                 fontStyle: .headline04,
                 textColorInfo: .white))
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 30
        return $0
    }(UIStackView(arrangedSubviews: [firstInfoStackView,
                                     secondInfoStackView]))
    
    private lazy var firstInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .top
        $0.spacing = 22
        return $0
    }(UIStackView(arrangedSubviews: [firstInfoImageView,
                                     firstInfoLabelStackView]))
    
    private let firstInfoImageView: UIImageView = {
        $0.image = UIImage(named: "locationImage")
        $0.constraint(.widthAnchor, constant: 22)
        $0.constraint(.heightAnchor, constant: 30.8)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let firstInfoLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 6
        
        let titleLabel = BasicLabel(
            contentText: "주변 밴드 구경하기",
            fontStyle: .contentBold,
            textColorInfo: .white
        )
        
        let contentLabel: BasicLabel = {
            $0.numberOfLines = 2
            $0.addLabelSpacing(lineSpacing: 3)
            return $0
        }(BasicLabel(
            contentText: "주위의 밴드가 어떤 활동을 하고 있는지 둘러보고\n나의 취향에 맞는 밴드를 찾아보세요.",
            fontStyle: .caption,
            textColorInfo: .white))
        
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(contentLabel)
        return $0
    }(UIStackView())
    
    private lazy var secondInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .top
        $0.spacing = 13
        return $0
    }(UIStackView(arrangedSubviews: [secondInfoImageView,
                                     secondInfoLabelStackView]))
    
    private let secondInfoImageView: UIImageView = {
        let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 19)
        $0.image = UIImage(named: "textBalloon")
        $0.image?.withConfiguration(imageConfiguation)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let secondInfoLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 6
        
        let titleLabel = BasicLabel(
            contentText: "밴드 하고싶은 말 남기기",
            fontStyle: .contentBold,
            textColorInfo: .white
        )
        
        let contentLabel: BasicLabel = {
            $0.numberOfLines = 2
            $0.addLabelSpacing(lineSpacing: 3)
            return $0
        }(BasicLabel(
            contentText: "주변 밴드 하고싶은 말에 내 포지션과 실력을 남기고,\n자랑하고, 소통해보세요.",
            fontStyle: .caption,
            textColorInfo: .white))
        
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(contentLabel)
        return $0
    }(UIStackView())
    
    private lazy var makeBandButton: BottomButton = {
        $0.setTitle("밴드 만들러가기", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        let action = UIAction { [weak self] _ in
            self?.delegate?.makeBandButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func setupLayout() {
        self.addSubview(containerView)
        containerView.constraint(leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 centerY: self.centerYAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        
        containerView.addSubview(titleStackView)
        titleStackView.constraint(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  trailing: containerView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 30, left: 26, bottom: 0, right: 26))
        
        containerView.addSubview(dismissButton)
        dismissButton.constraint(top: containerView.topAnchor,
                                 trailing: containerView.trailingAnchor,
                                 padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20))
        
        containerView.addSubview(infoStackView)
        infoStackView.constraint(top: titleStackView.bottomAnchor,
                                  leading: containerView.leadingAnchor,
                                  trailing: containerView.trailingAnchor,
        padding: UIEdgeInsets(top: 36, left: 31, bottom: 0, right: 31))
        
        containerView.addSubview(makeBandButton)
        makeBandButton.constraint(top: infoStackView.bottomAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: containerView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 45, left: 18, bottom: 20, right: 18))
    }
}
