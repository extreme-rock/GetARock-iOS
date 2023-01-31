//
//  PositionPlusCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

class PositionPlusCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View
    
    private let containerView: UIView = {
        $0.backgroundColor = .dark02
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.gray02.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIView())
    
    private let plusImageView: UIImageView = {
        $0.image = UIImage(systemName: "plus")
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.constraint(to: self.contentView)
        self.containerView.constraint(.widthAnchor, constant: 172)
        self.containerView.constraint(.heightAnchor, constant: 138)
        
        containerView.addSubview(plusImageView)
        self.plusImageView.constraint(centerX: self.containerView.centerXAnchor,
                                      centerY: self.containerView.centerYAnchor)
    }
    
}
