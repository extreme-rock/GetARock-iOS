//
//  ApproveDeletionViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/03/31.
//

import AuthenticationServices
import UIKit

final class ApproveDeletionViewController: BaseViewController {
    
    //MARK: - View
    
    private let titleLabel: UILabel = {
        $0.text = "\(UserDefaultStorage.name )님!\n모여락과 이별하신다니\n아쉬워요😢"
        $0.font = .setFont(.largeTitle02)
        $0.numberOfLines = 3
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.text = "탈퇴하기 전에 아래 내용을 확인해주세요."
        $0.font = .setFont(.headline03)
        $0.numberOfLines = 3
        $0.textColor = .white
        $0.addLabelSpacing(lineSpacing: 10)
        return $0
    }(UILabel())
    
    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark04
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private let contentLabel: BasicLabel = {
        $0.numberOfLines = 0
        return $0
    }(BasicLabel(contentText: """
                    탈퇴시 주의사항
                    
                    * 내 프로필, 소속밴드, 방명록  등 모든 활동 정보가 삭제되며, 삭제된 데이터는 복구할 수 없어요.
                    
                    * 현재 소속된 밴드의 리더인 경우, 탈퇴가 불가능합니다. 밴드를 삭제하거나 리더 권한을 다른 멤버에게 양도해주세요.
                    """,
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var approveButton: BottomButton = {
        $0.setTitle("탈퇴하기", for: .normal)
        let action = UIAction { _ in
            // TODO: 리더 여부에 따라 분기처리 (리더인 경우 addIgnoreDeleteAccountModal 실행)
            self.showAlertSheet()
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
    
    // MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.view.addSubview(titleStackView)
        titleStackView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 45, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(containerView)
        containerView.constraint(top: titleStackView.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16))
        containerView.constraint(.heightAnchor, constant: 223)
        
        self.containerView.addSubview(contentLabel)
        contentLabel.constraint(top: containerView.topAnchor,
                                leading: containerView.leadingAnchor,
                                bottom: containerView.bottomAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25))
        
        self.view.addSubview(approveButton)
        approveButton.constraint(bottom: view.bottomAnchor,
                                 centerX: view.centerXAnchor,
                                 padding: UIEdgeInsets(top: 42, left: 16, bottom: 40, right: 16))
    }
    
    private func showAlertSheet() {
        let alertSheet = UIAlertController(title: "정말 탈퇴하시겠어요?",
                                           message: "회원님의 모든 활동 정보가 삭제되며,\n삭제된 데이터는 복구할 수 없어요.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        let action = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
            self.deleteAccount()
            let initialViewController = LandingViewController()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = initialViewController
            }
        }
        
        alertSheet.addAction(cancel)
        alertSheet.addAction(action)
        
        present(alertSheet, animated: true)
    }
    
    private func revokeAppleID() {
//        if UserDefaultStorage.userID != "" {
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.revokeCredential(withUser: UserDefaultStorage.userID) { error in
//                if let error = error {
//                    print("Error revoking Apple Sign In credential: \(error.localizedDescription)")
//                } else {
//                    print("Successfully revoked Apple Sign In credential.")
//                }
//            }
//            UserDefaults.standard.removeObject(forKey: "appleSignInUserID")
//        } else {
//            print("There are no userID")
//        }
    }
}

// MARK: - 계정 삭제 DELETE 요청

extension ApproveDeletionViewController {
    private func deleteAccount() {
        var urlComponent = URLComponents(string: "https://api.ryomyom.com/member")
        let memeberIdQuery = URLQueryItem(name: "id", value: String(UserDefaultStorage.memberID))
        
        urlComponent?.queryItems = [memeberIdQuery]
        
        guard let url = urlComponent?.url else {
            print("An error has occurred while creating URL")
            return
        }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            if let error = error {
                print("")
                print("====================================")
                print("[requestGet : http get 요청 실패]")
                print("fail : ", error.localizedDescription)
                print("====================================")
                print("")
                return
            } else if let data = data {
                do {
                    // status 코드 체크 실시
                    let successsRange = 200..<300
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
                    else {
                        print("")
                        print("====================================")
                        print("[requestGet : http get 요청 에러]")
                        print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                        print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
                        print("====================================")
                        print("")
                        return
                    }
                    
                    // response 데이터 획득
                    let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    let decodedData = try JSONDecoder().decode(DeleteAccountVO.self, from: data)
                    
                    print("")
                    print("====================================")
                    print("[requestGet : http get 요청 성공]")
                    print("resultCode : ", resultCode)
                    print("decodedData : ", decodedData)
                    print("====================================")
                    print("")
                    
                } catch {
                    print("Error decoding response data: \(error)")
                }
            } else {
                print("No response data received.")
            }
        }
        dataTask.resume()
    }
}
