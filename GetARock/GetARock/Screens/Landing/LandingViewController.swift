//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import AuthenticationServices
import UIKit

final class LandingViewController: UIViewController {
    
    // MARK: - Property
    
    private var loginData = LoginVO(memberId: 0)
    
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
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - 서버에 identity token 전송
    
    private func sendIdentityToken(_ token: String) {
        let semaphore = DispatchSemaphore(value: 0)
        
        let headers = [
            "social-token": "\(token)"
        ]
        var resultString = ""
        
        let urlComponent = URLComponents(string: "https://api.ryomyom.com/signup")
        guard let url = urlComponent?.url else {
            print("An error has occurred while creating URL")
            return
        }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            if let error = error {
                print("")
                print("====================================")
                print("[requestGet : http get 요청 실패]")
                print("fail : ", error.localizedDescription)
                print("====================================")
                print("")
                
                semaphore.signal()
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
                        
                        semaphore.signal()
                        return
                    }
                    
                    // response 데이터 획득, 디코딩
                    let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    let decodedData = try JSONDecoder().decode(LoginVO.self, from: data)
                    self.loginData = decodedData
                    
                    print("")
                    print("====================================")
                    print("[requestGet : http get 요청 성공]")
                    print("resultCode : ", resultCode)
                    print("loginData : " , self.loginData)
                    print("====================================")
                    print("")
                    
                    semaphore.signal()
                    
                } catch {
                    print("Error decoding response data: \(error)")
                }
            } else {
                print("No response data received.")
            }
        }
        // network 통신 실행
        dataTask.resume()
        
        // 네트워크 통신 동기화 대기
        semaphore.wait()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LandingViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    guard let token = appleIDCredential.identityToken else { return }
                    guard let tokenToString = String(data: token, encoding: .utf8) else { return }
                    self.sendIdentityToken(tokenToString)
                    
                    // member ID 받아옴 -> 유저디폴트에 저장 후 메인맵으로 연결
                    if self.loginData.memberId != nil {
                        UserDefaultHandler.setMemberID(memberID: self.loginData.memberId!)
                        DispatchQueue.main.async {
                            self.presentMaipMapViewController()
                        }
                        UserDefaultHandler.setUserID(userID: userIdentifier)
                    } else {
                        // 애플 로그인 성공은 했지만 서버에 member ID는 없음 -> 회원가입
                        // TODO: 회원가입 페이지로 연결
                        print("아직 없지롱")
                    }
                    
                    break
                case .revoked:
                    break
                case .notFound:
                    break
                default:
                    break
                }
            }
        }

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the authorization error
        print(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension LandingViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - 뷰 이동 함수

extension LandingViewController {
    private func presentMaipMapViewController() {
        let viewController = MainMapViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
    }
}
