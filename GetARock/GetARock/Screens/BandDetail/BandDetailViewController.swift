//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import SafariServices
import UIKit

struct BandList {
    var bandId: Int
    let name: String
    var memberCount: Int
    var memberAge: String
}

final class BandDetailViewController: UIViewController {
    
    // MARK: - Property
    
    enum BandSelectMenuDefaultSize {
        static let width: CGFloat = 250
        static let height: CGFloat = 120
    }
    
    enum EntryPoint {
        case myBand
        case otherBand
    }
    
    private let myBands: [BandList]?
    private let entryPoint: EntryPoint
    
    //TODO: - 추후 상세페이지의 밴드 아이디를 지도로부터 받아와야함
    private var bandID = "25"
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
        switch self.entryPoint {
        case .myBand:
            $0.setupMoreButton()
            if self.myBands?.count ?? 0 > 1 {
                $0.setupToggleButtonLayout()
            }
        case .otherBand:
            break
        }
        return $0
    }(BandTopInfoView(name: bandData.name, address: bandData.address))
    
    lazy var bandDetailContentView = DetailContentView(detailInfoType: .band, bandData: bandData)
    
    private lazy var bandSelectMenuView = BandListMenuTableView(bandNames: self.myBands?.map { $0.name } ?? [])
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchBandData(with: self.myBands?.first?.bandId)
            setupLayout()
        }
        configureDelegate()
        setNotification()
    }
    
    // MARK: - Init
    
    init(myBands: [BandList]?, entryPoint: EntryPoint) {
        self.myBands = myBands
        self.entryPoint = entryPoint
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
        
        switch self.entryPoint {
        case .myBand:
            view.addSubview(bandSelectMenuView)
        case .otherBand:
            break
        }
        
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentSNSViewController(_:)),
                                               name: Notification.Name.presentSNSSafariViewController,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentSongViewController(_:)),
                                               name: Notification.Name.presentSongSafariViewController,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentMypageDetailViewController(_:)),
                                               name: NSNotification.Name.presentMypageDetailViewController,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showBandModifyActionSheet(_:)),
                                               name: NSNotification.Name.showBandModifyActionSheet,
                                               object: nil)
    }
    
    @objc private func presentSNSViewController(_ notification: Notification) {
        guard let snsURL = notification.userInfo?["snsURL"] as? String else { return }
        guard let url = URL(string: snsURL) else { return }
        let snsSafariViewController = SFSafariViewController(url: url)
        self.present(snsSafariViewController, animated: true)
    }
    
    @objc private func presentSongViewController(_ notification: Notification) {
        guard let songURL = notification.userInfo?["songURL"] as? String else { return }
        guard let url = URL(string: songURL) else { return }
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true)
    }
    
    @objc private func presentMypageDetailViewController(_ notification: Notification) {
        guard let memberID = notification.userInfo?["memberID"] as? Int else { return }
        let mypageVC = MypageDetailViewController(userID: memberID)
        //        self.navigationController?.pushViewController(mypageVC, animated: true)
        mypageVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(mypageVC, animated: true)
    }
    
    @objc private func showBandModifyActionSheet(_ notification: Notification) {
        // TODO - 유저 정보에 따라 분기처리 해야함..
        showActionSheet(isCreator: true)
    }
    
    func showActionSheet(isCreator: Bool) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let positionModify = UIAlertAction(title: "내 포지션 수정", style: .default) { [weak self] _ in
            print("밴드 포지션 수정하기로 연결")
            
        }
        let bandModify = UIAlertAction(title: "밴드 수정", style: .default) { [weak self] _ in
            print("밴드 수정하기로 연결 (밴드 어드민만)")
            //
        }
        let banddelete = UIAlertAction(title: "밴드 삭제", style: .destructive) { [weak self] _ in
            print("밴드 삭제 연결 (밴드 어드민만)")
        }
        actionSheet.addAction(positionModify)
        if isCreator == true {
            actionSheet.addAction(bandModify)
            actionSheet.addAction(banddelete)
        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

// MARK: - Get BandData

extension BandDetailViewController {
    func fetchBandData(with id: Int?) async {
        guard let id else { return }
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

extension BandDetailViewController: BandListMenuTableViewDelegate {
    func fetchSelectedBandInfo(indexPath: IndexPath) {
        Task {
            await fetchBandData(with: self.myBands?[indexPath.row].bandId)
            NotificationCenter.default.post(name: NSNotification.Name.configureBandData,
                                            object: nil,
                                            userInfo: ["bandInfo": self.bandData])
            self.removeBandSelectMenu()
        }
    }
}

//MARK: BandSelectMenu관련 Method
extension BandDetailViewController {
    private func dropdownBandSelectMenu() {
        bandSelectMenuView.frame = CGRect(
            x: view.frame.origin.x + 15,
            y: view.frame.origin.y + 67,
            width: BandSelectMenuDefaultSize.width,
            height: 0
        )
        
        // MARK: layout이 잡히기전 contentSize가 88로 잡혀서 frame 설정 후 layoutIfNeeded()
        // 로 contentSize를 바로 업데이트하여 높이를 가져옴
        self.bandSelectMenuView.performBatchUpdates {
            DispatchQueue.main.async { [weak self] in
                self?.animate { [weak self] in
                    self?.bandSelectMenuView.frame = CGRect(
                        x: (self?.view.frame.origin.x ?? 0) + 15,
                        y: (self?.view.frame.origin.y ?? 0) + 67,
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
                        x: (self?.view.frame.origin.x ?? 0) + 15,
                        y: (self?.view.frame.origin.y ?? 0) + 67,
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
                    x: (self?.view.frame.origin.x ?? 0) + 15,
                    y: (self?.view.frame.origin.y ?? 0) + 67,
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

