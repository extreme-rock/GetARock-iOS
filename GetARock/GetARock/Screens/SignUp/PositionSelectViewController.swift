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
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false))
    ]
    
    private lazy var positionCollectionView = PositionCollectionView(entryPoint: .position, items: positions)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureDelegate()
    }

    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func setupLayout() {
        self.view.addSubview(positionCollectionView)
        positionCollectionView.constraint(top: view.topAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: view.bottomAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
    }

}

extension PositionSelectViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        return true
    }
}
