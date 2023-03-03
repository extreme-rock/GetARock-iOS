//
//  SetAuthorizationViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/10.
//

import CoreLocation
import UIKit

final class SetAuthorizationViewController: UIViewController {
    
    //MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var isFirstAuthorizationChangeRun = true
    
    //MARK: - View
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, requestAuthorizationLabel]))
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.setFont(.largeTitle01)
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.text = "프로필을 완성했어요.\n축하합니다!"
        return $0
    }(UILabel())
    
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
        
        let titleLabel = BasicLabel(
            contentText: "위치(선택)",
            fontStyle: .contentBold,
            textColorInfo: .white
        )
        
        let contentLabel = BasicLabel(
            contentText: "현 위치 기반 주변 밴드, 모여락 정보 제공",
            fontStyle: .content,
            textColorInfo: .white
        )

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
        $0.setTitle("확인", for: .normal)
        let action = UIAction { _ in
//            self.requestLocationAuthorization()
            self.view.window?.rootViewController = MainMapViewController(isFromSignUp: true)
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        setLocationManager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Method
    
    private func setLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
   
    private func attribute() {
        self.view.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        
        self.view.addSubview(titleStackView)
        titleStackView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 65, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(authorizationContainerView)
        authorizationContainerView.constraint(top: titleStackView.bottomAnchor,
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

//MARK: - 권한 관련 Method

extension SetAuthorizationViewController {
    private func requestLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.showRequestLocationServiceAlert()
        default:
            return
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n'설정 > 개인정보 보호 및 보안'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            self?.requestNotificationAutorization()
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    private func requestNotificationAutorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, error in
                if isGranted {
                    //TODO: 동의 시 뷰 연결
                    print(isGranted)
                } else {
                    //TODO: 비동의 시 뷰 연결
                    print(isGranted)
                }
            }
    }
}

extension SetAuthorizationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if !isFirstAuthorizationChangeRun {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted:
                return
            case .authorizedAlways, .authorizedWhenInUse:
                manager.startUpdatingLocation()
                self.requestNotificationAutorization()
            case .denied:
                self.requestNotificationAutorization()
            @unknown default:
                return
            }
        }
        
        self.isFirstAuthorizationChangeRun = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
