//
//  SongListUICollectionView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/27.
//

import UIKit

protocol SongListViewDelegate: AnyObject {
    func presentInAppSafari(with link: String)
}

enum SongListType {
    case create
    case detail
}

final class SongListView: UIView {
    
    // MARK: - Property
    
    weak var delegate: SongListViewDelegate?
    private var songList: [Song]?
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
    
    private lazy var collectionView = {
        $0.register(
            SongListCollectionViewCell.self,
            forCellWithReuseIdentifier: "SongListCollectionViewCell"
        )
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout))
    
    // MARK: - Init
    
    init(songListType: SongListType, songList: [SongListVO]? = nil) {
        self.songListType = songListType
        if let songList {
            self.songList = songList.map {
                Song(title: $0.name, artist: $0.artist, link: $0.link)
            }
        }
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
}

// MARK: - DataSource

extension SongListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.songList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SongListCollectionViewCell",
            for: indexPath) as? SongListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configure(
            data: songList?[indexPath.item],
            songListType: songListType,
            index: indexPath.item
        )
        return cell
    }
}

extension SongListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch songListType {
        case .create:
            return
        case .detail:
            guard let link = self.songList?[indexPath.item].link else { return }
            self.delegate?.presentInAppSafari(with: link)
        }
    }
}

// MARK: - SongListDeleteDelegate

extension SongListView: SongListDeleteDelegate {
    func deleteSongList(index: Int) {
        BandDummyData.testBands[0].song?.remove(at: index)
        self.collectionView.reloadData()
    }
}
