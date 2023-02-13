//
//  LeaderPositionSelectViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

final class LeaderPositionSelectViewController: UIViewController {

    //MARK: Properties

    // 최종적으로 보내야하는 데이터 양식입니다. 이 데이터를 계속 전달하기보다는
    // 전역변수로 하나의 인스턴스로 만들어서 공유한다
    // 왜냐면 각각의 뷰컨에서 네비게이션 될 때마다 바뀐 데이터를 전달하는게 번거롭다
    private var bandCreationData = ModelData.bandCreationData

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

            var selectedInstruments: [InstrumentList] = []
            //MARK: 선택된 Cell은 데이터모델에 추가
            for index in 0..<self.positions.count {

                guard let cell =  self.positionCollectionView.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PositionCollectionViewCell else { return }

                if !cell.isSelected {
                    selectedInstruments.append(InstrumentList(name: cell.positionNameLabel.text ?? ""))
                }
            }

            let bandLeader: MemberList = MemberList(memberId: 0, name: "루키", memberState: .admin, instrumentList: selectedInstruments)

            self.memberList.append(bandLeader)
            // append로 처리할 수 있으나 대체하는 것이 좋다고 생각
            // 왜냐면 다시 이전으로 네비게이션되었을 때 수정하면 데이터 자체가 통쨰로 바꿔야되니까
            self.bandCreationData.memberList = self.memberList
            print(self.bandCreationData)
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addObservePositionPlusButtonTapped()
        addObservePositionDeleteButtonTapped()
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

