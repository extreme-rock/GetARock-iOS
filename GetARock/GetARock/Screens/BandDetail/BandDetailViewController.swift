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
    private var bandID = "172"
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
        if self.myBands.count > 1 {
            $0.setupToggleButtonLayout()
        }
        return $0
    }(BandTopInfoView(name: bandData.name, address: bandData.address))
    
    lazy var bandDetailContentView = DetailContentView(detailInfoType: .band, bandData: bandData)
    
    private lazy var bandSelectMenuView = BandListMenuTableView(bandNames: self.myBands.map { $0.name })
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await fetchBandData(with: self.myBands.first?.bandId)
            setupLayout()
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
            top: self.view.safeAreaLayoutGuide.topAnchor,
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
    func showBandOptionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyBandAction = UIAlertAction(title: "밴드 수정", style: .default) { _ in
            print("밴드수정")
        }
        
        let modifyMyPositionAction = UIAlertAction(title: "내 포지션 수정", style: .default) { _ in
            print("내 포지션 수정")
        }
        
        let deleteMyBandAction = UIAlertAction(title: "밴드 삭제", style: .destructive) { _ in
            let viewController = DeleteBandViewController()
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [modifyBandAction, modifyMyPositionAction, deleteMyBandAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        self.present(actionSheet, animated: true)
    }
    
    func didBandSelectButtonTapped(isBandSelectButton: Bool) {
        isBandSelectButton ? dropdownBandSelectMenu() : removeBandSelectMenu()
    }
}

extension BandDetailViewController: BandListMenuTableViewDelegate {
    func fetchSelectedBandInfo(indexPath: IndexPath) {
        Task {
            await fetchBandData(with: self.myBands[indexPath.row].bandId)
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

extension BandDetailViewController: DeleteBandViewControllerDelegate {
    func didDeleteBandButtonTapped() {
        guard let window = UIApplication.shared.windows.first else { return }
        let viewController = MainMapViewController()
        viewController.setupLayoutDeleteBandNoticeView()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
