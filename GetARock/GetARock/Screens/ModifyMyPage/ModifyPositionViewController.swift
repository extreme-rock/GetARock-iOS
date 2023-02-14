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
    
    //MARK: - View
    
    private lazy var positionCollectionView = PositionCollectionView(
        cellType: .position,
        items: positions,
        isNeedHeader: true,
        headerView: PositionSelectCollectionViewHeader()
    )
    
    private let nextButton: BottomButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(BottomButton())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addObservePositionPlusButtonTapped()
        addObservePositionDeleteButtonTapped()
    }
    
    //MARK: - Method
    
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
