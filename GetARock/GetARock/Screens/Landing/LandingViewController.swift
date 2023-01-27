//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {

     let test = ActiveGradationButton(borderBounds: CGRect(x: 0, y: 0, width: 200, height: 50))
         let test1 = Dark02Button()
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(test)
         test.setTitle("dddddd", for: .normal)
         test.constraint( centerX: view.centerXAnchor, centerY: view.centerYAnchor)
         test.constraint(.widthAnchor, constant: 200)
         test.constraint(.heightAnchor, constant: 50)
         
         test1.setTitle("dfiefj", for: .normal)
         view.addSubview(test1)
         test1.constraint(top: test.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
         test1.constraint(.heightAnchor, constant: 50)
     }
 }
#imageLiteral(resourceName: "simulator_screenshot_74A65ABE-BB7C-4B75-9AFF-F7BDDC9E6993.png")
