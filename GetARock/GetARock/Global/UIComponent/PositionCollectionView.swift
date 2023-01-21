//
//  PositionCollectionView.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

enum PositionSection: Int {
    case main
}
//
//타인이 보는 내 밴드
//isUser: true,
//isLeader: true,
//userName: "기타",
//imageName: "guitar",
//다루는악기: ["기타", "보컬"]

struct Position {
    let instrumentName: String
    let imageName: String
    let isETC: Bool
}
//
//포지션 선택
//name: "기타",
//imageName: "guitar",
//isMain: true, // 가장 처음 선택한 것을 true
//isETC: true // name중 기본 name에 없는 것을 etc로 판단할지, isetc를 넣을지? etc는 x를 넣어줘야함
//

final class PositionCollectionView: UICollectionView {
    
    
    private var dataSource: UICollectionViewDiffableDataSource<PositionSection, String>?
    private var instruemnts: [Position] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
  
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
    }
}

// MARK: - diffable
extension PositionCollectionView {
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<PositionSection, UIColor>(collectionView: self.colorCollectionView) { collectionView, indexPath, color -> UICollectionViewCell? in
           
         
        }
    }
}
