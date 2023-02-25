//
//  InstructionViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/22.
//

import UIKit

final class InstructionViewController: UIViewController {
    
    // MARK: View
    
    private lazy var labelStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))
    
    private let titleLabel: UILabel
    
    private let subTitleLabel: UILabel
    
    private let contentView: UIView
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark04
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    private let confirmButton: BottomButton = {
        $0.setTitle("확인했습니다.", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        $0.titleLabel?.textColor = .white
        return $0
    }(BottomButton())
    
    // MARK: Init
    
    init(titleLabel: UILabel, subTitleLabel: UILabel, contentView: UIView) {
        self.titleLabel = titleLabel
        self.subTitleLabel = subTitleLabel
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attribute()
        self.setupLayout()
    }
    
    // MARK: Method
    
    private func attribute() {
        self.view.backgroundColor = .dark03
    }
    
    private func setupLayout() {
        self.view.addSubview(labelStackView)
        labelStackView.constraint(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 58, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(containerView)
        containerView.constraint(top: labelStackView.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
        
        self.containerView.addSubview(contentView)
        contentView.constraint(top: containerView.topAnchor,
                               leading: containerView.leadingAnchor,
                               bottom: containerView.bottomAnchor,
                               trailing: containerView.trailingAnchor,
                               padding: UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25))
        
        self.view.addSubview(confirmButton)
        confirmButton.constraint(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  centerX: view.centerXAnchor,
                                  padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
