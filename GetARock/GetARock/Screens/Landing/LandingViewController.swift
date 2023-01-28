//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: BaseViewController {
    
    let test = SelectCollectionView(widthState: .fixedWidth, items: ["20대 미만","20 대", "60대 이상", "30 대", "40 대"], widthSize: 100)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(test)
        
        test.constraint(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        bottom: view.bottomAnchor,
                        trailing: view.trailingAnchor,
                        padding: UIEdgeInsets(top: 300, left: 10, bottom: 0, right: 0))
        
    }
}
