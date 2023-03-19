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
    private var userID = "18"
    //    private var userData = UserInformationVO(
    //        userID: 0,
    //        name: "",
    //        age: "",
    //        gender: "",
    //        introduction: nil,
    //        bandList: nil,
    //        instrumentList: [],
    //        snsList: nil,
    //        eventList: nil,
    //        commentEventList: nil)
    private var userData = UserInformationVO(
        userID: 0,
        name: "노엘노엘노엘노엘노엘노엘노엘노엘노엘노엘노엘노엘노엘노엘",
        age: "TWENTIES",
        gender: "MAN",
        introduction: "안녕하세요 노엘입니다.",
        bandList: [BandListVO(bandID: 10,
                              name: "극 - 락",
                              memberCount: 6,
                              memberAge: "20-60대"),
                   BandListVO(bandID: 12,
                              name: "모여락",
                              memberCount: 6,
                              memberAge: "20-60대")],
        instrumentList: [InstrumentListVO(instrumentID: 1,
                                          isMain: true,
                                          name: "guitar"),
                         InstrumentListVO(instrumentID: 2,
                                          isMain: false,
                                          name: "bass"),
                         InstrumentListVO(instrumentID: 3,
                                          isMain: false,
                                          name: "캐스터네츠")],
        snsList: nil,
        eventList: nil,
        commentEventList: nil)
    
    // MARK: - View
    
    private lazy var mypageTopInfoView = MypageTopInfoView(
        userName: userData.name,
        userGender: userData.gender,
        userAge: userData.age
    )
    
    private lazy var userInfomationView = UserInformationView(userData: userData)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        Task {
            //await fetchUserData()
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
        view.addSubview(userInfomationView)
        userInfomationView.constraint(
            top: mypageTopInfoView.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
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
