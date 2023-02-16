//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    
    private let button = UIButton(type: .system)
    
     override func viewDidLoad() {
         super.viewDidLoad()
         button.setTitle("모달", for: .normal)
         view.addSubview(button)
         button.constraint(centerX: view.centerXAnchor,
                           centerY: view.centerYAnchor)
         addAction()
         
     }
    
    func addAction() {
        let action = UIAction { _ in
            let vc = PositionSelectViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
 }
