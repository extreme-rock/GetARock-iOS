//
//  PlusPositionViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

class PlusPositionViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        $0.font = .setFont(.headline01)
        $0.text = "가능한 포지션을 추가해주세요"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = .setFont(.caption)
        $0.text = "기타 포지션은 최대 공백 포함 10자까지 작성 가능합니다."
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let textField = BasicTextField(placeholder: "추가 할 포지션을 입력해 주세요.")
    
    private let addPositionButton: BottomButton = {
        $0.setTitle("추가", for: .normal)
        $0.tintColor = .white
        return $0
    }(BottomButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.constraint(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 59, left: 15, bottom: 0, right: 15))
        
        self.view.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15))
        
        self.view.addSubview(textField)
        textField.constraint(top: subTitleLabel.bottomAnchor,
                             centerX: view.centerXAnchor,
                             padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(addPositionButton)
        addPositionButton.constraint(top: textField.bottomAnchor,
                                     centerX: view.centerXAnchor,
                                     padding: UIEdgeInsets(top: 52, left: 0, bottom: 0, right: 0))
    }
}
