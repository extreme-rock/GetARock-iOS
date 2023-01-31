//
//  PositionSelectViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/30.
//

import UIKit

final class PositionSelectViewController: UIViewController {
    
    private let positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false)),
        .plusPosition
    ]
    
    private lazy var positionCollectionView = PositionCollectionView(entryPoint: .position, items: positions)
    
    private let nextButton: BottomButton = {
        $0.setTitle("다음", for: .normal)
        return $0
    }(BottomButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        addObservePositionPlusButtonTapped()
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
                                                name: Notification.Name("showPositionPlusModal"),
                                                object: nil)
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
    
    @objc
    private func showPositionPlusModal() {
        let viewController = PlusPositionViewController()
        present(viewController, animated: true)
    }
}

extension PositionSelectViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        return true
    }
}
