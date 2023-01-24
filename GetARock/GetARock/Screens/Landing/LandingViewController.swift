//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {

     private let button = BottomButton()
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(button)
         view.backgroundColor = .white
         button.setTitle("다음", for: .normal)
//         button.isEnabled = false
         button.constraint( centerX: view.centerXAnchor, centerY: view.centerYAnchor)
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
