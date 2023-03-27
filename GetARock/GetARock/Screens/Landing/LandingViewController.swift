//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

final class LandingViewController: UIViewController {
    
    // MARK: - Property
    
    private let titleLabel: BasicLabel = {
        $0.numberOfLines = 3
        return $0
    }(BasicLabel(contentText: "음악을 즐겁게\n밴드를 다양하게\n여기 모두 모여樂!",
                 fontStyle: .largeTitle01,
                 textColorInfo: .white))
    
    private let subLabel: BasicLabel = {
        $0.numberOfLines = 1
        return $0
    }(BasicLabel(contentText: "내 주변 밴드 커뮤니티, 모여락",
                 fontStyle: .subTitle,
                 textColorInfo: .white))
    
    private let appleButton: ASAuthorizationAppleIDButton = {
        $0.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
        $0.cornerRadius = 40
        $0.constraint(.heightAnchor, constant: 49)
        return $0
    }(ASAuthorizationAppleIDButton(type: .signIn, style: .white))
    
    private let backgroundImageView: UIImageView = {
        $0.image = ImageLiteral.landingBackground
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView(frame: UIScreen.main.bounds))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        self.view.insertSubview(backgroundImageView, at: 0)
        
        self.view.addSubview(titleLabel)
        self.titleLabel.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            padding: UIEdgeInsets(top: 140, left: 16, bottom: 0, right: 0)
        )
        
        self.view.addSubview(subLabel)
        self.subLabel.constraint(
            top: self.titleLabel.bottomAnchor,
            leading: self.view.leadingAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 0)
        )
        
        self.view.addSubview(appleButton)
        self.appleButton.constraint(
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor,
            centerX: self.view.centerXAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 115, right: 16)
        )
    }
    
    // MARK: - 애플 로그인 요청
    
    @objc func handleSignInWithApple() {
    }
     }
 }
