//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    //TODO: - 추후 상세페이지의 밴드 아이디를 지도로부터 받아와야함
    private var bandID = "72"
    private var bandData = BandInformationVO(
        bandID: 0,
        name: "",
        age: "",
        introduction: "",
        address: AddressVO(city: "",
                         street: "",
                         detail: "",
                         longitude: 0.0,
                         latitude: 0.0),
        memberList: [],
        songList: [],
        snsList: [],
        eventList: [],
        commentList: []
    ){
        didSet{
            let bandDataDict: [String: [CommentList]?] = ["data": bandData.commentList]
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "load"),
                object: nil,
               userInfo: bandDataDict as [AnyHashable : Any]
            )
        }
    }
    
    // MARK: - View
    
    lazy var bandTopInfoView: BandTopInfoView? = nil
    lazy var bandDetailContentView: DetailContentView? = nil
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: 비동기 테스크가 만들어짐 -> 비동기함수가 아닌거에 비동기함수를 넣어야할때
        Task {
            await getBandData()
            
            print(bandData.memberList)
            bandTopInfoView = BandTopInfoView(name: bandData.name, address: bandData.address)
            bandDetailContentView = DetailContentView(type: .band, bandData: bandData)
            
            //MARK: 데이터를 넣어준 다음에 뷰를 그리는 순서를 잡아주기 위해 레이아웃 코드를 여기 넣어야함.(Task 안에 코드는 순서대로 진행됨)
            view.addSubview(bandTopInfoView ?? UIView(frame: .zero))
            bandTopInfoView?.constraint(
                top: self.view.topAnchor,
                leading: self.view.leadingAnchor,
                trailing: self.view.trailingAnchor
            )
            
            view.addSubview(bandDetailContentView ?? UIView(frame: .zero))
            bandDetailContentView?.constraint(
                top: bandTopInfoView?.bottomAnchor,
                leading: self.view.leadingAnchor,
                bottom: self.view.bottomAnchor,
                trailing: self.view.trailingAnchor
            )
        }
    }
}

// MARK: - Get BandData

extension BandDetailViewController {
    
    func getBandData() async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/band")
        let idQuery = URLQueryItem(name: "id", value: bandID)
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(BandInformationVO.self, from: data)
//            print("❤️ Response data raw : \(data)")
//            print("응답 내용 : \(response)")
            self.bandData = decodedData
        } catch {
            print(error)
            print("bad news! decoding error occuerd")
        }
    }
    
}
