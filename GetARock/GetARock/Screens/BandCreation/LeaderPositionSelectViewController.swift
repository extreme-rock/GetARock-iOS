//
//  LeaderPositionSelectViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

final class LeaderPositionSelectViewController: BaseViewController {
    
    //MARK: - Property
    
    private var bandCreationData = BasicDataModel.bandCreationData
    
    private var memberList: [MemberList] = []
    
    //MARK: - View
    
    //TODO: 추후 유저 데이터에서 유저가 가능하다고 응답한 악기들로 대체되어야함.
    private var positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false))
    ]
    
    private lazy var positionCollectionView: PositionCollectionView = PositionCollectionView(
        cellType: .position,
        items: positions,
        isNeedHeader: true,
        headerView: LeaderPositionSelectHeaderView()
    )
    
    private lazy var nextButton: BottomButton = {
        $0.setTitle("다음", for: .normal)
        let action = UIAction { _ in
            self.addSelectedPositionData()
            self.navigateToNext()
        }
        $0.isEnabled = false
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        setNotificationObserver()
    }

    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }

    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setNextButtonState),
                                               name: Notification.Name.didTapPositionItem,
                                               object: nil)
    }
    
    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func updateDataSourceIndex(from startIndex: Int, endIndex: Int) {
        for index in startIndex..<endIndex {
            positionCollectionView.updateCellIndex(at: IndexPath(item: index, section: 0))
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(positionCollectionView)
        self.view.addSubview(nextButton)
        
        positionCollectionView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: nextButton.topAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        
        
        nextButton.constraint(bottom: view.bottomAnchor,
                              centerX: view.centerXAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0))
    }
}

extension LeaderPositionSelectViewController {
    private func addSelectedPositionData() {
        let selectedInstruments: [InstrumentList] = self.positionCollectionView.getSelectedInstruments()
        //TODO: 추후 밴드를 생성하려는 유저의 닉네임으로 바꿔야함
        let firstMember: MemberList = MemberList(memberId: 0, name: "user", memberState: .admin, instrumentList: selectedInstruments)
        if self.memberList.isEmpty {
            self.memberList.append(firstMember)
        } else {
            self.memberList.removeAll(keepingCapacity: true)
            self.memberList.append(firstMember)
        }
        self.bandCreationData.memberList = self.memberList
    }
    
    private func navigateToNext() {
        let nextVC = BandMemberAddViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }

    @objc
    func setNextButtonState() {
        if self.positionCollectionView.getSelectedInstruments().isEmpty {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}

//MARK: 포지션 최대 선택 개수 제한
extension LeaderPositionSelectViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        if selectedItemsCount > 1 { return false }
        return true
    }
}
