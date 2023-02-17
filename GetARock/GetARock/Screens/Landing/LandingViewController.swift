//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    private let genderSelectCollectionView = SelectCollectionView(
        widthState: .fixed,
        items: ["남자", "여자"],
        widthSize: (UIScreen.main.bounds.width - 40) / 2,
        itemSpacing: 8
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(genderSelectCollectionView)
        genderSelectCollectionView.constraint(top: view.topAnchor,
                                              leading: view.leadingAnchor,
                                              bottom: view.bottomAnchor,
                                              trailing: view.trailingAnchor,
        padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        
    }

 }
