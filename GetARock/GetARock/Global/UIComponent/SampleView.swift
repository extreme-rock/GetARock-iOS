//
//  SampleView.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class SampleView: UIView {
    // 머지 이전 삭제 예정
    private let collectionView = PositionCollectionView(entryPoint: .position, items: [.position(Position(instrumentName: "기타", imageName: "guitar", isETC: false)),
                                                                                   .position(Position(instrumentName: "베이스", imageName: "bass", isETC: false)),
                                                                                   .position(Position(instrumentName: "보컬", imageName: "vocal", isETC: false)),
                                                                                   .position(Position(instrumentName: "drum", imageName: "drum", isETC: false)),
                                                                                       .position(Position(instrumentName: "콘트라베이스으으으", imageName: "etc", isETC: false)),
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.constraint(top: view.topAnchor,
                                  leading: view.leadingAnchor, bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor,
        padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LandingViewController: PositionCollectionViewDelegate {
   func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
       return true
   }
}
