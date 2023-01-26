//
//  SongListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/25.
//

import UIKit

class SongListView: UIView {
    // MARK: - Property
    
    enum SongListType {
        case create
        case detail
    }
    
    private var songListType: SongListType
    
    var songs = [
        Song(title: "Don't Look Back in Anger", artist: "OASIS", link: nil),
        Song(title: "Champagne Supernova", artist: "OASIS", link: "https://youtu.be/tI-5uv4wryI"),
        Song(title: "Little by Little", artist: "OASIS", link: "https://youtu.be/ic-Na--7_NI")
    ]
    
    // MARK: - View
    
    let collectionView = {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView())
    
    
    // MARK: - Init
    
    init(songListType: SongListType) {
            self.songListType = songListType
            super.init(frame: .zero)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
            addSubview(collectionView)
            self.collectionView.constraint(to: self)
        }
    
    private func setupSongList() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SongListCollectionViewCell.self,
            forCellWithReuseIdentifier: "SongListCollectionViewCell"
        )
    }
}

extension SongListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
}

extension SongListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SongListCollectionViewCell",
            for: indexPath
        ) as? SongListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        switch songListType {
        case .create:
            cell.
        }
        
        return cell
    }
}
