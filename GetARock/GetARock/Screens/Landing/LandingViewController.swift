//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: BaseViewController {
     
     let testTextField = BasicTextField(placeholder: "테스트 용입니다")

     override func viewDidLoad() {
         super.viewDidLoad()
//         hidekeyboardWhenTappedAround()
         self.view.addSubview(testTextField)
         testTextField.constraint(.widthAnchor, constant: 250)
         testTextField.constraint(centerX: self.view.centerXAnchor, centerY: self.view.centerYAnchor)
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
