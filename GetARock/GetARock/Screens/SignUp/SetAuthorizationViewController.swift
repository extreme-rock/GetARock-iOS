//
//  SetAuthorizationViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/10.
//

import UIKit

final class SetAuthorizationViewController: UIViewController {
    
    //MARK: - View
    
    private let requestAuthorizationLabel: UILabel = {
        $0.font = UIFont.setFont(.headline01)
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.text = "더욱 편리한 모여락 이용을 위해,\n권한 허용이 필요해요"
        return $0
    }(UILabel())
    
    private let authorizationContainerView: UIView = {
        $0.backgroundColor = .dark04
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private lazy var authorizationStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 30
        return $0
    }(UIStackView(arrangedSubviews: [locationAuthorizationStackView,
                                     alertAuthorizationStackView]))
    
    private lazy var locationAuthorizationStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.spacing = 18
        return $0
    }(UIStackView(arrangedSubviews: [locationAuthorizationImageView,
                                     locationAuthorizationLabelStackView]))
    
    private let locationAuthorizationImageView: UIImageView = {
        $0.image = UIImage(named: "locationImage")
        $0.constraint(.widthAnchor, constant: 22)
        $0.constraint(.heightAnchor, constant: 30.8)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let locationAuthorizationLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        
        let titleLabel: UILabel = {
            $0.text = "위치(선택)"
            $0.font = .setFont(.contentBold)
            $0.textColor = .white
            return $0
        }(UILabel())
        
        let contentLabel: UILabel = {
            $0.text = "현 위치 기반 주변 밴드, 모여락 정보 제공"
            $0.font = .setFont(.content)
            $0.textColor = .white
            return $0
        }(UILabel())
        
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(contentLabel)
        return $0
    }(UIStackView())
    
    private lazy var alertAuthorizationStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [alertAuthorizationImageView,
                                     alertAuthorizationLabelStackView]))
    
    private let alertAuthorizationImageView: UIImageView = {
        $0.image = ImageLiteral.bellSymbol
        $0.tintColor = .white
        $0.constraint(.widthAnchor, constant: 25)
        $0.constraint(.heightAnchor, constant: 27.9)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let alertAuthorizationLabelStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        
        let titleLabel: UILabel = {
            $0.text = "알림(선택)"
            $0.font = .setFont(.contentBold)
            $0.textColor = .white
            return $0
        }(UILabel())
        
        let contentLabel: UILabel = {
            $0.text = "밴드 초대 및 권한, 내 활동, 주요 공지 알람 수신"
            $0.font = .setFont(.content)
            $0.textColor = .white
            return $0
        }(UILabel())
        
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(contentLabel)
        return $0
    }(UIStackView())
    
    private let authorizationCautionLabel: UILabel = {
        $0.font = UIFont.setFont(.caption)
        $0.numberOfLines = 2
        $0.textColor = .gray02
        $0.text = "선택 권한의 경우, 허용하지 않아도 서비스를 이용할 수 있으나\n일부 서비스 이용이 제한 될 수 있습니다."
        return $0
    }(UILabel())
    
    private lazy var approveButton: BottomButton = {
        $0.setTitle("동의 후 시작하기", for: .normal)
        let action = UIAction { _ in
            self.requestNotificationAutorization()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
    }
    
    //MARK: - Method
    
    private func requestNotificationAutorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, error in
                if isGranted {
                    print(isGranted)
                } else {
                    print(isGranted)
                }
            }
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        
        self.view.addSubview(requestAuthorizationLabel)
        requestAuthorizationLabel.constraint(top: view.topAnchor,
                                             leading: view.leadingAnchor,
                                             trailing: view.trailingAnchor,
                                             padding: UIEdgeInsets(top: 65, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(authorizationContainerView)
        authorizationContainerView.constraint(top: requestAuthorizationLabel.bottomAnchor,
                                              leading: view.leadingAnchor,
                                              trailing: view.trailingAnchor,
                                              padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16))
        authorizationContainerView.constraint(.heightAnchor, constant: 172)
        
        self.authorizationContainerView.addSubview(authorizationStackView)
        authorizationStackView.constraint(top: authorizationContainerView.topAnchor,
                                          leading: authorizationContainerView.leadingAnchor,
                                          bottom: authorizationContainerView.bottomAnchor,
                                          trailing: authorizationContainerView.trailingAnchor,
                                          padding: UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25))
        
        self.view.addSubview(authorizationCautionLabel)
        authorizationCautionLabel.constraint(top: authorizationContainerView.bottomAnchor,
                                             leading: view.leadingAnchor,
                                             trailing: view.trailingAnchor,
                                             padding: UIEdgeInsets(top: 25, left: 27, bottom: 0, right: 27))
        
        self.view.addSubview(approveButton)
        approveButton.constraint(bottom: view.bottomAnchor,
                                 centerX: view.centerXAnchor,
                                 padding: UIEdgeInsets(top: 42, left: 16, bottom: 40, right: 16))
    }
}
