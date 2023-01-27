//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {

     let test = ActiveGradationButton(borderBounds: CGRect(x: 0, y: 0, width: 200, height: 50))
         
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black
         view.addSubview(test)
         test.setTitle("dddddd", for: .normal)
         test.constraint( centerX: view.centerXAnchor, centerY: view.centerYAnchor)
         test.constraint(.widthAnchor, constant: 200)
         test.constraint(.heightAnchor, constant: 50)
     }
 }
