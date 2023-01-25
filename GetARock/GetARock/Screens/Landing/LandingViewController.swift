//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: BaseViewController {
    
    let test = SelectCollectionView(entryPoint: .flexableWidth, items: ["20대 미만","20 대", "60대 이상", "30 대", "40 대"], widthSize: 25)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(test)
        
        test.constraint(top: view.topAnchor,
                        leading: view.leadingAnchor,
                        bottom: view.bottomAnchor,
                        trailing: view.trailingAnchor,
                        padding: UIEdgeInsets(top: 300, left: 10, bottom: 0, right: 0))
        
    }
}

// MARK: 기본 TextField 실험 코드
//class LandingViewController: BaseViewController {
//
//    let testTextField = BasicTextField(placeholder: "테스트 용입니다")
//
//    lazy var testStackView = UIStackView(arrangedSubviews: [testTextField])
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.view.addSubview(testStackView)
//
//        testStackView.axis = .vertical
//        testStackView.constraint(leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
//        testStackView.constraint(centerX: self.view.centerXAnchor, centerY: self.view.centerYAnchor)
//    }
//}
