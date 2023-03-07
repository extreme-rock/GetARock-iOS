//
//  MypageDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/07.
//

import UIKit

final class MypageDetailViewController: UIViewController {
    
    // MARK: - Property
    
    //TODO: - 추후 상세페이지의 멤버 아이디를 지도로부터 받아와야함
    private var userID = "22"
    private var userData = UserInformationVO(
        userID: 0,
        name: "",
        age: "",
        gender: "",
        introduction: nil,
        bandList: nil,
        instrumentList: [],
        snsList: nil,
        eventList: nil,
        commentEventList: nil)
    
    // MARK: - View
    
    private lazy var mypageTopInfoView = MypageTopInfoView(
        userName: userData.name,
        userGender: userData.gender,
        userAge: userData.age
    )
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        Task {
            await fetchUserData()
            print(userData)
            setupLayout()
        }
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        view.addSubview(mypageTopInfoView)
        mypageTopInfoView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            trailing: self.view.trailingAnchor
        )
    }
    
    
}

// MARK: - fetchBandData

extension MypageDetailViewController {
    
    func fetchUserData() async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/member")
        let idQuery = URLQueryItem(name: "id", value: userID)
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(UserInformationVO.self, from: data)
            print("Response data raw : \(data)")
            print("응답 내용 : \(response)")
            self.userData = decodedData
        } catch {
            print(error)
            print("bad news! decoding error occuerd")
        }
    }
    
}
