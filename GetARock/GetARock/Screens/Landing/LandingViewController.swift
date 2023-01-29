//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    
    lazy var segment = DarkSegmentedControl(items: ["내밴드", "내 정보"])
    let segmnet2 = MainPurpleSegmentedControl(buttonTitles: ["내밴드", "내 정보", "난나나"])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(segment)
        segment.constraint(top: view.topAnchor,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           padding: UIEdgeInsets(top: 300, left: 20, bottom: 0, right: 20))
        segment.constraint(.heightAnchor, constant: 50)
        
        view.addSubview(segmnet2)
        segmnet2.constraint(top: segment.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20))
        segmnet2.constraint(.heightAnchor, constant: 60)
       
    }
}
