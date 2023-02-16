//
//  PositionPlusCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

final class PlusPositionCollectionViewCell: UICollectionViewCell {

    // MARK: - View
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark02
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
    private let plusPositionButton: UIButton = {
        $0.setImage(ImageLiteral.plusSymbol, for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addActionToPlusButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.constraint(to: self.contentView)
        self.containerView.constraint(.heightAnchor, constant: 138)
        
        containerView.addSubview(plusPositionButton)
        self.plusPositionButton.constraint(to: self.containerView)
    }
    
    private func addActionToPlusButton() {
        let action = UIAction { _ in
            NotificationCenter.default.post(name: Notification.Name(StringLiteral.showPositionPlusModal),
                                            object: nil)
        }
        self.plusPositionButton.addAction(action, for: .touchUpInside)
    }
}
