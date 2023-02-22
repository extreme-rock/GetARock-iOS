//
//  BandCreationDecisionViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/12.
//

import UIKit

final class BandCreationDecisionViewController: UIViewController {
    
    //MARK: - View
    
    private let pageIndicatorLabel = BasicLabel(contentText: "3/3",
                                                fontStyle: .subTitle,
                                                textColorInfo: .gray02)
    
    private let titleLabel: UILabel = {
        $0.font = .setFont(.largeTitle01)
        $0.text = "모여락에서 활동할\n밴드가 있으신가요?"
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = .setFont(.subTitle)
        $0.text = "이미 가입하고 싶은 밴드가 모여락에 있다면\n밴드 리더로부터 초대를 받아 가입할 수 있어요!"
        $0.textColor = .gray02
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let makeBandButton: UIButton = {
        $0.setImage(UIImage(named: "makeMyBandBanner"), for: .normal)
        return $0
    }(UIButton())
    
    private let makeBandTitleLabel = BasicLabel(contentText: "내 밴드 만들기",
                                                fontStyle: .subTitle2,
                                                textColorInfo: .white)
    
    
    
    private let makeBandContentLabel: UILabel = {
        $0.font = .setFont(.contentLight)
        $0.text = "내 밴드를 만들어서 모여락에서\n다른 밴드와 소통해보세요!"
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let passMakingBandButton: UIButton = {
        $0.setBackgroundColor(.dark02, for: .normal)
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIButton())
    
    private let passMakingBandTitleLabel = BasicLabel(contentText: "밴드 다음에 만들기",
                                                      fontStyle: .subTitle2,
                                                      textColorInfo: .white)
    
    
    
    private let passMakingBandContentLabel: UILabel = {
        $0.font = .setFont(.contentLight)
        $0.text = "밴드가 없으면 모여락 이벤트를 만들 수 없어요🥹\n하지만 이벤트 참여와 소통은 가능해요!"
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        addActionToButtons()
    }
    
    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.view.addSubview(pageIndicatorLabel)
        pageIndicatorLabel.constraint(top: self.view.safeAreaLayoutGuide.topAnchor,
                                      leading: self.view.leadingAnchor,
                                      trailing: self.view.trailingAnchor,
                                      padding: UIEdgeInsets(top: 20, left: 17, bottom: 0, right: 0))
        
        self.view.addSubview(titleLabel)
        titleLabel.constraint(top: pageIndicatorLabel.bottomAnchor,
                              leading: self.view.leadingAnchor,
                              trailing: self.view.trailingAnchor,
                              padding: UIEdgeInsets(top: 6, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: self.view.leadingAnchor,
                                 trailing: self.view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 16, bottom: 49, right: 16))
        
        self.view.addSubview(makeBandButton)
        makeBandButton.constraint(top: subTitleLabel.bottomAnchor,
                                  leading: self.view.leadingAnchor,
                                  trailing: self.view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 43, left: 16, bottom: 0, right: 16))
        makeBandButton.constraint(.heightAnchor, constant: 160)
        
        self.makeBandButton.addSubview(makeBandTitleLabel)
        makeBandTitleLabel.constraint(top: makeBandButton.topAnchor,
                                      leading: makeBandButton.leadingAnchor,
                                      padding: UIEdgeInsets(top: 42, left: 37, bottom: 0, right: 0))
        
        self.makeBandButton.addSubview(makeBandContentLabel)
        makeBandContentLabel.constraint(top: makeBandTitleLabel.bottomAnchor,
                                        leading: makeBandButton.leadingAnchor,
                                        padding: UIEdgeInsets(top: 14, left: 37, bottom: 0, right: 0))
        
        self.view.addSubview(passMakingBandButton)
        passMakingBandButton.constraint(top: makeBandButton.bottomAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        passMakingBandButton.constraint(.heightAnchor, constant: 160)
        
        self.passMakingBandButton.addSubview(passMakingBandTitleLabel)
        passMakingBandTitleLabel.constraint(top: passMakingBandButton.topAnchor,
                                            leading: passMakingBandButton.leadingAnchor,
                                            padding: UIEdgeInsets(top: 42, left: 37, bottom: 0, right: 0))
        
        self.passMakingBandButton.addSubview(passMakingBandContentLabel)
        passMakingBandContentLabel.constraint(top: passMakingBandTitleLabel.bottomAnchor,
                                              leading: passMakingBandButton.leadingAnchor,
                                              padding: UIEdgeInsets(top: 14, left: 37, bottom: 0, right: 0))
    }
    
    private func addActionToButtons() {
        // TODO: 각 상황에 따라 VC 연결하기
        let makeBandAction = UIAction { _ in
            print("make")
        }
        
        let passMakeBandAction = UIAction { _ in
            print("pass")
        }
        self.makeBandButton.addAction(makeBandAction, for: .touchUpInside)
        self.passMakingBandButton.addAction(passMakeBandAction, for: .touchUpInside)
    }
}
