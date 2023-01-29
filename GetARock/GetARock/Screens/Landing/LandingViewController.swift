//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {

     let test : SongListView = {
            return $0
        }(SongListView(songListType: .create))

        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = .dark01
            
            self.view.addSubview(test)
            self.test.constraint(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.safeAreaLayoutGuide.leadingAnchor,
                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                trailing: view.safeAreaLayoutGuide.trailingAnchor,
                padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        }
    }
 
