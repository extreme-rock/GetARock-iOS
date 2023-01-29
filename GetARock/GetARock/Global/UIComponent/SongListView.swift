//
//  SongListUICollectionView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/27.
//

import UIKit

enum SongListType {
    case create
    case detail
}

class SongListView: UIView {
    
    // MARK: - Property
    
    private var songListType: SongListType
    
    private enum Size {
        static let cellWidth: CGFloat = (UIScreen.main.bounds.width * 0.9)
    }
    
    // MARK: - View
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: Size.cellWidth, height: 70)
        $0.minimumLineSpacing = 10
        return $0
    }(UICollectionViewFlowLayout())
    
    lazy var collectionView = {
        $0.register(
            SongListCollectionViewCell.self,
            forCellWithReuseIdentifier: "SongListCollectionViewCell"
        )
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout))
    
    // MARK: - Init
    
    init(songListType: SongListType) {
        self.songListType = songListType
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        addSubview(collectionView)
        self.collectionView.constraint(to: self)
    }
    
    @objc func deleteSongList(sender : UIButton) {
        testband[0].song?.remove(at: sender.tag)
        collectionView.reloadData()
    }
}

// MARK: - DataSource

extension SongListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return testband[0].song?.count ?? -1
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SongListCollectionViewCell",
            for: indexPath) as? SongListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(
            data: testband[0].song?[indexPath.item] ?? nil,
            songListType: songListType
        )
        
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteSongList(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - SongListDeleteDelegate

//extension SongListView: SongListDeleteDelegate {
//    func DeleteSongListList(index: Int) {
//        testband[0].song?.remove(at: index)
//        collectionView.reloadData()
//    }
//}
