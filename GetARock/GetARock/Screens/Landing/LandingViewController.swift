//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    
    private let button = UIButton(type: .system)
    
    deinit {
        print("deinit, landingviewcontroller")
    }
     override func viewDidLoad() {
         super.viewDidLoad()
         self.view.backgroundColor = .blue03
         button.setTitle("모달", for: .normal)
         view.addSubview(button)
         button.constraint(centerX: view.centerXAnchor,
                           centerY: view.centerYAnchor)
         addAction()
         
     }
    
    func addAction() {
        let action = UIAction { [weak self] _ in
            let vc = ModifyMyPageViewController()
//            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
 }

class vc1: UIViewController {
    
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
        let action = UIAction { [weak self] _ in
            let vc = ModifyMyPageViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
//            self?.navigationController?.pushViewController(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
}
