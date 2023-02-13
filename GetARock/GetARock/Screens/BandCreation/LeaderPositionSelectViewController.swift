//
//  LeaderPositionSelectViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

final class LeaderPositionSelectViewController: UIViewController {
    
    //MARK: Properties
    private var bandCreationData = BasicDataModel.bandCreationData
    
    private var memberList: [MemberList] = []
    
    private var positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false)),
        .plusPosition
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
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    //MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addObservePositionPlusButtonTapped()
        addObservePositionDeleteButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func addObservePositionPlusButtonTapped() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showPositionPlusModal),
                                               name: Notification.Name(StringLiteral.showPositionPlusModal),
                                               object: nil)
    }
    
    @objc
    private func showPositionPlusModal() {
        let viewController = PlusPositionViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    private func addObservePositionDeleteButtonTapped() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deletePosition(_:)),
                                               name: Notification.Name(StringLiteral.deletePositionCell),
                                               object: nil)
    }
    
    @objc
    private func deletePosition(_ notification: Notification) {
        guard let deleteIndexPath = notification.userInfo?["index"] as? Int else { return }
        positions.remove(at: deleteIndexPath)
        self.positionCollectionView.applySnapshot(with: positions)
        self.updateDataSourceIndex(from: deleteIndexPath, endIndex: positions.count - 1)
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
    //MARK: collectionView에서 선택된 Cell만 데이터에 추가
    private func addSelectedPositionData() {
        var selectedInstruments: [InstrumentList] = []
        for index in 0..<self.positions.count - 1 {
            
            guard let cell =  self.positionCollectionView.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PositionCollectionViewCell else { return }
            
            if cell.isSelected {
                selectedInstruments.append(InstrumentList(name: cell.positionNameLabel.text ?? ""))
            }
        }
        
        //TODO: 추후 밴드를 생성하려는 유저의 닉네임으로 바꿔야함
        let bandLeader: MemberList = MemberList(memberId: 0, name: "user", memberState: .admin, instrumentList: selectedInstruments)
        
        self.memberList.append(bandLeader)
        self.bandCreationData.memberList = self.memberList
        //MARK: Merge 전 삭제 필요
        print(self.bandCreationData)
    }
    
    private func navigateToNext() {
        self.navigationController?.pushViewController(BandMemberAddViewController(), animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK: 포지션 최대 선택 개수 제한
extension LeaderPositionSelectViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        if selectedItemsCount > 1 { return false }
        return true
    }
}

//MARK: 포지션 추가
extension LeaderPositionSelectViewController: PlusPositionViewControllerDelegate {
    func addPosition(instrumentName: String) {
        let newPosition: Item = .position(Position(instrumentName: instrumentName,
                                                   instrumentImageName: .etc,
                                                   isETC: true))
        positions.insert(newPosition, at: positions.count - 1)
        self.positionCollectionView.applySnapshot(with: positions)
    }
}

