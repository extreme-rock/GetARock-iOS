//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    private var tableViewHeight: NSLayoutConstraint? = nil
    
    //TODO: - 추후 상세페이지의 밴드 아이디를 지도로부터 받아와야함
    private var bandID = "71"
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
                name: NSNotification.Name.loadBandData,
                object: nil,
               userInfo: bandDataDict as [AnyHashable : Any]
            )
        }
    }
    
    // MARK: - View
    
    lazy var bandTopInfoView: BandTopInfoView = {
        $0.delegate = self
        return $0
    }(BandTopInfoView(name: bandData.name, address: bandData.address))
    lazy var bandDetailContentView = DetailContentView(detailInfoType: .band, bandData: bandData)
    private lazy var bandSelectToggleTableView = BandSelectToggleTableView(bandNames: ["모여락", "락락"])
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchBandData()
            setupLayout()
            attribute()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.bandSelectToggleTableView.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubview(bandTopInfoView)
        bandTopInfoView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            trailing: self.view.trailingAnchor
        )
        
        view.addSubview(bandDetailContentView)
        bandDetailContentView.constraint(
            top: bandTopInfoView.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor
        )
        
        view.addSubview(bandSelectToggleTableView)
        bandSelectToggleTableView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            padding: UIEdgeInsets(top: 54, left: 17, bottom: 0, right: 0)
        )
        
        // MARK: tableViewHeight 설정 플로우
        self.tableViewHeight = self.bandSelectToggleTableView.heightAnchor.constraint(equalToConstant: 88)
        self.tableViewHeight?.isActive = true
        bandSelectToggleTableView.constraint(.widthAnchor, constant: 250)
        
        DispatchQueue.main.async {
            let size = self.bandSelectToggleTableView.contentSize
            self.tableViewHeight?.isActive = false
            self.tableViewHeight = self.bandSelectToggleTableView.heightAnchor.constraint(equalToConstant: size.height)
            self.tableViewHeight?.isActive = true
        }
    }
}


// MARK: - Get BandData

extension BandDetailViewController {
    
    func fetchBandData() async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/band")
        let idQuery = URLQueryItem(name: "id", value: bandID)
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(BandInformationVO.self, from: data)
            print("Response data raw : \(data)")
            print("응답 내용 : \(response)")
            self.bandData = decodedData
        } catch {
            print(error)
            print("bad news! decoding error occuerd")
        }
    }
    
}

extension BandDetailViewController: BandTopInfoViewDelegate {
    func didBandSelectButtonTapped(isBandSelectButton: Bool) {
        self.bandSelectToggleTableView.isHidden = !isBandSelectButton
    }
}
