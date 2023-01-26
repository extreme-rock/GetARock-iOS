//
//  SelectCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

enum WidthState {
    case fixedWidth
    case flexableWidth
}

final class SelectCollectionView: UIView {
    
    // MARK: - Property
    
    private let items: [String]
    private var widthState: WidthState
    private var widthSize: CGFloat

    // MARK: - View
    
    private lazy var collectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(150),
                                              heightDimension: .absolute(46))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(46))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(SelectCollectionViewCell.self, forCellWithReuseIdentifier: "SelectCollectionViewCell")
        return collectionView
    }()
    
    init(widthState: WidthState, items: [String], widthSize: CGFloat) {
        self.widthState = widthState
        self.items = items
        self.widthSize = widthSize
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.addSubview(collectionView)
        collectionView.constraint(to: self)
    }
}

extension SelectCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCollectionViewCell", for: indexPath) as? SelectCollectionViewCell else { return UICollectionViewCell() }
        
        var width: CGFloat
        var backgroundColor: UIColor
        
        switch widthState {
        case .fixedWidth:
            width = widthSize
            backgroundColor = .dark03
        case .flexableWidth:
            width = widthSize
            backgroundColor = .dark02
        }
        
        cell.setupLayout(width: width, widthState: widthState)
        cell.configure(color: backgroundColor, text: self.items[indexPath.item])
        
        return cell
    }
}
