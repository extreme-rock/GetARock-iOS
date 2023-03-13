//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

struct BandList {
    var bandId: Int
    let name: String
    var memberCount: Int
    var memberAge: String
}

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    enum BandSelectMenuDefaultSize {
        static let width: CGFloat = 250
        static let height: CGFloat = 120
    }
    
    private let myBands: [BandList]
    
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
    private lazy var bandSelectMenuView = BandSelectMenuTableView(bandNames: self.myBands.map { $0.name })
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchBandData()
            setupLayout()
//            touchScreenExceptBandSelectToggleView()
        }
        configureDelegate()
    }
    
    // MARK: - Init
    
    init(myBands: [BandList]){
        self.myBands = myBands
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Method
    
    private func configureDelegate() {
        self.bandSelectMenuView.selectDelegate = self
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
        
        view.addSubview(bandSelectMenuView)
    }
//
//    private func touchScreenExceptBandSelectToggleView() {
//        // TODO: bandTopInfo를 클릭하면 화면에서 터치를 받아오지 못함. why?
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc
//    func handleTap(_ sender: UITapGestureRecognizer) {
//        print(sender.location(in: view), bandSelectToggleTableView.frame)
//        if sender.state == .ended {
//            let location = sender.location(in: view)
//            print(bandSelectToggleTableView.frame.contains(location))
//            if !self.bandSelectToggleTableView.frame.contains(location) {
//                // Hide table view
//                self.removeBandSelectView()
//            }
//        }
//    }
}


// MARK: - Get BandData

extension BandDetailViewController {
    
    func fetchBandData() async {
        guard let firstBand = self.myBands.first else { return }
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/band")
        let idQuery = URLQueryItem(name: "id", value: String(firstBand.bandId))
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
    
    
    func fetchBandData2(with id: Int) async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/band")
        let idQuery = URLQueryItem(name: "id", value: String(id))
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
        isBandSelectButton ? dropdownBandSelectMenu() : removeBandSelectMenu()
    }
}

extension BandDetailViewController: BandSelectMenuTableViewDelegate {
    func fetchSelectedBandInfo(indexPath: IndexPath) {
        Task {
            await fetchBandData2(with: self.myBands[indexPath.row].bandId)
            NotificationCenter.default.post(name: NSNotification.Name.configureBandData,
                                            object: nil,
                                            userInfo: ["bandInfo": self.bandData])
        }
    }
}

//MARK: BandSelectMenu관련 Method
extension BandDetailViewController {
    private func dropdownBandSelectMenu() {
        bandSelectMenuView.frame = CGRect(
            x: view.frame.origin.x + 17,
            y: view.frame.origin.y + 57,
            width: BandSelectMenuDefaultSize.width,
            height: 0
        )
        
        // MARK: layout이 잡히기전 contentSize가 88로 잡혀서 frame 설정 후 layoutIfNeeded()
        // 로 contentSize를 바로 업데이트하여 높이를 가져옴
        self.bandSelectMenuView.performBatchUpdates {
            DispatchQueue.main.async { [weak self] in
                self?.animate { [weak self] in
                    self?.bandSelectMenuView.frame = CGRect(
                        x: (self?.view.frame.origin.x ?? 0) + 17,
                        y: (self?.view.frame.origin.y ?? 0) + 57,
                        width: BandSelectMenuDefaultSize.width,
                        height: BandSelectMenuDefaultSize.height
                    )
                }
            }
        } completion: { _ in
            DispatchQueue.main.async { [weak self] in
                self?.animate { [weak self] in
                    self?.bandSelectMenuView.layoutIfNeeded()
                    let contentSize = self?.bandSelectMenuView.contentSize
                    self?.bandSelectMenuView.frame = CGRect(
                        x: (self?.view.frame.origin.x ?? 0) + 17,
                        y: (self?.view.frame.origin.y ?? 0) + 57,
                        width: BandSelectMenuDefaultSize.width,
                        height: contentSize?.height ?? 50
                    )
                }
            }
        }
    }
    
    private func removeBandSelectMenu() {
        DispatchQueue.main.async { [weak self] in
            self?.animate { [weak self] in
                self?.bandSelectMenuView.frame = CGRect(
                    x: (self?.view.frame.origin.x ?? 0) + 17,
                    y: (self?.view.frame.origin.y ?? 0) + 57,
                    width: 250,
                    height: 0
                )
            }
        }
    }
    
    private func animate(of animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: animations)
    }
}
