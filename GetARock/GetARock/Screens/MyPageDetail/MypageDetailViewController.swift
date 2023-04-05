//
//  MypageDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import SafariServices
import UIKit

final class MypageDetailViewController: BaseViewController {
    
    // MARK: - Property

    enum NavigationBarOption {
        case hiddenTrue
        case hiddenFalse

        var isHidden: Bool {
            switch self {
            case .hiddenTrue: return true
            case .hiddenFalse: return false
            }
        }
    }
    private let memberId: Int
    private let navigationBarOption: NavigationBarOption
    //TODO: - 추후 상세페이지의 멤버 아이디를 지도로부터 받아와야함
    private lazy var userData: UserInformationVO = UserInformationVO(
        userID: UserDefaultStorage.memberID,
        name: "",
        age: "",
        gender: "",
        introduction: nil,
        bandList: [],
        instrumentList: [],
        snsList: [],
        eventList: [],
        commentEventList: []
    ) {
        didSet {
            self.mypageTopInfoView.configureModifiedUserInfo(name: userData.name,
                                                             age: userData.age,
                                                             gender: userData.gender)
            //TODO: SNS 변경되는 함수 만들어야함.
            self.userInfomationView.configureModifiedUserInfo(with: self.userData)
        }
    }
    
    // MARK: - View
    
    private lazy var mypageTopInfoView = MypageTopInfoView(
        userName: userData.name,
        userGender: userData.gender,
        userAge: userData.age
    )
    
    private lazy var userInfomationView = UserInformationView(userData: userData)
    
    // MARK: - Init
    
    init(navigationBarOption: NavigationBarOption, memberId: Int) {
        self.navigationBarOption = navigationBarOption
        self.memberId = memberId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchUserData(with: self.memberId)
            setupLayout()
            setNotification()
            configureDelegate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = self.navigationBarOption.isHidden
        Task {
            await fetchUserData(with: self.memberId)
        }
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//    }
//
    // MARK: - Method

    private func configureDelegate() {
        self.mypageTopInfoView.delegate = self
    }

    private func setupLayout() {
        view.addSubview(mypageTopInfoView)
        mypageTopInfoView.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.leadingAnchor,
            trailing: self.view.trailingAnchor
        )
        view.addSubview(userInfomationView)
        userInfomationView.constraint(
            top: mypageTopInfoView.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor
        )
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentSNSViewController(_:)),
                                               name: Notification.Name.presentSNSSafariViewController,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentBandCreation(_:)),
                                               name: NSNotification.Name.presentLeaderPositionSelectViewController,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentUserBandDetailViewController(_:)),
                                               name: NSNotification.Name.presentBandDetailViewController,
                                               object: nil)
    }
    
    @objc private func presentSNSViewController(_ notification: Notification) {
        guard let snsURL = notification.userInfo?["snsURL"] as? String else { return }
        guard let url = URL(string: snsURL) else { return }
        let snsSafariViewController = SFSafariViewController(url: url)
        self.present(snsSafariViewController, animated: true)
    }
    
    @objc private func presentBandCreation(_ notification: Notification) {
        Task {
            guard let instrumentList = await UserInfoNetworkManager.shared.fetchUserData(with: UserDefaultStorage.memberID)?.instrumentList else { return }
            let positions = instrumentList.map {
                let isETC = !["guitar", "drum", "vocal", "bass", "keyboard"].contains($0.name)
                return Item.position(Position(
                    instrumentName: Instrument(rawValue: $0.name)?.inKorean ?? $0.name,
                    instrumentImageName: Instrument(rawValue: $0.name) ?? .etc,
                    isETC: isETC)
                )
            }
            let bandCreationVC = UINavigationController(rootViewController: LeaderPositionSelectViewController(positions: positions))
            bandCreationVC.modalPresentationStyle = .fullScreen
            self.present(bandCreationVC, animated: true)
        }
    }
    
    //TODO - 지금 서버에 들어가는 멤버 밴드가 다른데 구엘한테 확인중....
    @objc private func presentUserBandDetailViewController(_ notification: Notification) {
        guard let selectbandData = notification.userInfo?["selectbandData"] as? BandList else { return }
        let bandDetailVC = BandDetailViewController(myBands: [selectbandData], entryPoint: .myBand)
        self.navigationController?.pushViewController(bandDetailVC, animated: true)
    }
}

// MARK: - fetchBandData

extension MypageDetailViewController {
    
    func fetchUserData(with memberId: Int) async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/member")
        let idQuery = URLQueryItem(name: "id", value: String(memberId))
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(UserInformationVO.self, from: data)
            print("Response data raw : \(data)")
            print("응답 내용 : \(response)")
            self.userData = decodedData
            print(decodedData.instrumentList, "in mypage")
        } catch {
            print(error)
            print("bad news! decoding error occuerd")
        }
    }
    
}

extension MypageDetailViewController: MypageTopInfoViewDelegate {
    func presentModifyMyPageViewController() {
        let userInfo =  User(memberId: self.userData.userID,
                             name: self.userData.name,
                             age: self.userData.age,
                             gender: self.userData.gender,
                             introduction: self.userData.introduction,
                             instrumentList: self.userData.instrumentList.map {
            InstrumentList(name: $0.name)
        },
                             snsList: self.userData.snsList.map {
            SnsList(type: $0.snsType, link: $0.link)
        })

        let viewController = ModifyMyPageViewController(userInfo: userInfo)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}
