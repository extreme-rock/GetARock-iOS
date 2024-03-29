//
//  PositionSelectViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/30.
//

import UIKit

final class PositionSelectViewController: BaseViewController {
    
    private var positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false)),
        .plusPosition
    ]
    
    private lazy var positionCollectionView = PositionCollectionView(
        cellType: .position,
        items: positions,
        isNeedHeader: true,
        headerView: PositionSelectCollectionViewHeader(viewType: .withPageIndicator)
    )
    
    private lazy var nextButton: BottomButton = {
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        let action = UIAction { _ in
            self.showUserInfoInputViewController()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addAllObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func setupLayout() {
        self.view.addSubview(positionCollectionView)
        self.view.addSubview(nextButton)
        
        positionCollectionView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: nextButton.topAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16))
        
        
        nextButton.constraint(bottom: view.bottomAnchor,
                              centerX: view.centerXAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0))
    }
    
    private func showUserInfoInputViewController() {
        let selectedInstrument = self.positionCollectionView.getSelectedInstruments()
        let viewController = UserInfoInputViewController(instrumentList: selectedInstrument)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - observer 관련 Method

extension PositionSelectViewController {
    private func addAllObserver() {
        addObserveShowPositionPlusModal()
        addObserveDelePositionCell()
        addObserveDeselectAllPosition()
        addObserveToggleNextButtonEnabled()
    }
    
    private func addObserveDeselectAllPosition() {
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
    
    private func addObserveShowPositionPlusModal() {
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
    
    private func addObserveDelePositionCell() {
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
    
    private func addObserveToggleNextButtonEnabled() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleNextButtonEnabled),
            name: Notification.Name.toggleNextButtonEnbaled,
            object: nil)
    }
    
    @objc
    private func toggleNextButtonEnabled() {
        self.nextButton.isEnabled.toggle()
    }
}

extension PositionSelectViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        return true
    }
}

extension PositionSelectViewController: PlusPositionViewControllerDelegate {
    func addPosition(instrumentName: String) {
        let newPosition: Item = .position(Position(instrumentName: instrumentName,
                                                   instrumentImageName: .etc,
                                                   isETC: true))
        positions.insert(newPosition, at: positions.count - 1)
        self.positionCollectionView.applySnapshot(with: positions)
    }
}
