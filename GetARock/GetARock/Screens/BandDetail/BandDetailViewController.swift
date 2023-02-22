//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    //서버에서 Get하는 데이터 양식
    private var bandData = BandInformationVO(
        bandID: 0,
        name: "",
        introduction: "",
        age: "",
        address: Address(city: "",
                         street: "",
                         detail: "",
                         longitude: 0.0,
                         latitude: 0.0),
        memberList: [],
        songList: [],
        snsList: [],
        eventList: [],
        commentList: []
    )
    
    // MARK: - View
    
    lazy var bandTopInfoView = BandTopInfoView()
    lazy var bandDetailContentView = DetailContentView(type: .band, bandData: bandData)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //비동기 테스크가 만들어짐 -> 비동기함수가 아닌거에 비동기함수를 넣어야할때
        Task{
            await getBandData()
            print("가져오기 성공")
            print(bandData)
        }
        
        view.addSubview(bandTopInfoView)
        bandTopInfoView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        view.addSubview(bandDetailContentView)
        bandDetailContentView.constraint(
            top: bandTopInfoView.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
    }
}

extension BandDetailViewController {
    
    func getBandData() async {
        var queryURLComponent = URLComponents(string: "http://43.201.55.66:8080/band")
        let idQuery = URLQueryItem(name: "id", value: "1")
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }

        do {
            //MARK: 데이터 받아오기
            let (data, response) = try await URLSession.shared.data(from: url)

            //MARK: 데이터 디코딩
            let decodedData = try JSONDecoder().decode(BandInformationVO.self, from: data)
                print("Response data raw: \(data)")
                print("fetch Data")
                print("\(response)")
                self.bandData = decodedData
        } catch {
            print("bad news! decoding error occuerd")
        }
    }
}
