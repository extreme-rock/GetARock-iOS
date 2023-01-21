//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {
     
     let button: UIButton = {
         $0.setTitle("노엘천사", for: .normal)
         return $0
     }(UIButton())
     
//     let testview: UIView = {
//         return $0
//     }(UIView())
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         button.applyMainGradient()
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(button)
         self.button.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 200, left: 50, bottom: 200, right: 50)
         )

//         view.addSubview(testview)
//         self.button.constraint(
//            top: self.view.topAnchor,
//            leading: self.view.leadingAnchor,
//            bottom: self.view.bottomAnchor,
//            trailing: self.view.trailingAnchor,
//            padding: UIEdgeInsets(top: 200, left: 50, bottom: 200, right: 50)
//         )
         
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
