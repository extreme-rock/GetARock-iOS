//
//  SelectCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

final class SelectCollectionViewCell: UICollectionViewCell {
    // 간격 입력받고, 테두리 배경색 입력받고,
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray02.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.content)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(width: CGFloat, widthState: WidthState) {
        self.contentView.addSubview(containerView)
        self.containerView.constraint(to: contentView)
        
        self.containerView.addSubview(label)
        switch widthState {
        case .fixedWidth:
            self.containerView.constraint(.widthAnchor, constant: width)
            self.label.constraint(top: containerView.topAnchor,
                                  bottom: containerView.bottomAnchor,
                                  centerX:  containerView.centerXAnchor ,
                                  padding: UIEdgeInsets(top: 15, left: 0, bottom: 13, right: 0))
            
        case .flexableWidth:
            self.label.constraint(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  bottom: containerView.bottomAnchor,
                                  trailing: containerView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 15, left: width, bottom: 13, right: width))
        }
        
    }
    
    func configure(color: UIColor, text: String) {
        self.containerView.backgroundColor = color
        self.label.text = text
    }
}