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
            let vc = ModifyMyPageViewController(
                userInfo: User(memberId: 15,
                               name: "Dake",
                               age: "TWENTIES",
                               gender: "MAN",
                               introduction: "안녕하십니가 데이크입니다용",
                               instrumentList: [InstrumentList(name: "기타"), InstrumentList(name: "캐스터네츠")],
                               snsList: [SnsList(type: .instagram, link: "dake"),
                                         SnsList(type: .youtube, link: "dake"),
                                         SnsList(type: .soundcloud, link: "dake")])
            )
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
 }
