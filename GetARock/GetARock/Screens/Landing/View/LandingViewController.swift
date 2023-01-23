//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {
     
     private let collectionView = PositionCollectionView()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .white
         view.addSubview(collectionView)
         collectionView.constraint(top: view.topAnchor,
                                   leading: view.leadingAnchor, bottom: view.bottomAnchor,
                                   trailing: view.trailingAnchor,
         padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
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
