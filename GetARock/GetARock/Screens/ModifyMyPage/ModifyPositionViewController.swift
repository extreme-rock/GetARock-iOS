//
//  ModifyPositionViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/13.
//

import UIKit

final class ModifyPositionViewController: UIViewController {
    
    //MARK: - Property
    
    private var positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false)),
        .plusPosition
    ]
    
    private var selectedPositions: [InstrumentList] = []
    
    //MARK: - View
    
    private lazy var positionCollectionView = PositionCollectionView(
        cellType: .position,
        items: positions,
        isNeedHeader: true,
        headerView: PositionSelectCollectionViewHeader(viewType: .withoutPageIndicator)
    )
    
    //MARK: - Init
    
    init(selectedPositions: [InstrumentList]) {
        self.selectedPositions = selectedPositions
        let selectedETCInstrumentList: [InstrumentList] = selectedPositions.filter {
            !["보컬", "기타", "키보드", "드럼", "베이스"].contains($0.name)
        }
        let selectedETCItem: [Item] = selectedETCInstrumentList.map {
            Item.position(Position(instrumentName: $0.name,
                                     instrumentImageName: .etc, isETC: true))
        }
        self.positions.insert(contentsOf: selectedETCItem, at: self.positions.count - 1)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(PositionSelectCollectionViewHeader.self)
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addAllObserver()
        configureUserPosition()
    }

    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func setupLayout() {
        self.view.addSubview(positionCollectionView)
        
        positionCollectionView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: view.bottomAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }
    
    private func configureUserPosition() {
        DispatchQueue.main.async {
            self.positionCollectionView.selectItems(with: self.selectedPositions)
        }
    }
    
    func instrumentList() -> [InstrumentList] {
        return self.positionCollectionView.getSelectedInstruments()
    }
    
    func checkCompleteButtonEnabledState() -> Bool {
        let selectedPosition = self.positionCollectionView.getSelectedInstruments()
        let isSelectedPosition = !selectedPosition.isEmpty
        return isSelectedPosition
    }
}

// MARK: - Observer 관련 Method

extension ModifyPositionViewController {
    private func addAllObserver() {
        addObservePositionPlusButtonTapped()
        addObservePositionDeleteButtonTapped()
        addObserveDeselectAllPositionButtonTapped()
    }
    
    private func addObserveDeselectAllPositionButtonTapped() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deselectAllPosition),
            name: Notification.Name.deselectAllPosition,
            object: nil)
    }
    
    @objc
    private func deselectAllPosition() {
        self.positionCollectionView.deselectAllItem()
    }
    
    private func addObservePositionPlusButtonTapped() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showPositionPlusModal),
            name: Notification.Name.showPositionPlusModal,
            object: nil)
    }
    
    @objc
    private func showPositionPlusModal() {
        let viewController = PlusPositionViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    private func addObservePositionDeleteButtonTapped() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deletePosition(_:)),
            name: Notification.Name.deletePositionCell,
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
    
}

// MARK: - Delegate

extension ModifyPositionViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        return true
    }
}

extension ModifyPositionViewController: PlusPositionViewControllerDelegate {
    func addPosition(instrumentName: String) {
        let newPosition: Item = .position(Position(instrumentName: instrumentName,
                                                   instrumentImageName: .etc,
                                                   isETC: true))
        positions.insert(newPosition, at: positions.count - 1)
        self.positionCollectionView.applySnapshot(with: positions)
    }
}
