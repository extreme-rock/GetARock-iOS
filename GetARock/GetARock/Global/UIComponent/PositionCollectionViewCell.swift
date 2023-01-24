//
//  PositionCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

final class PositionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    override var isSelected: Bool {
        didSet {
            self.applySelectedState()
        }
    }
    
    // MARK: - View
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark01
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let positionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let positionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.headline01)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var mainLabel: UILabel = {
       let label = UILabel()
        label.text = "main"
        label.font = .setFont(.content)
        label.textColor = .mainPurple
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    private func setupLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.constraint(to: contentView)
        self.containerView.constraint(.widthAnchor, constant: 172)
        self.containerView.constraint(.heightAnchor, constant: 138)
        
        self.containerView.addSubview(positionImageView)
        self.positionImageView.constraint(to: containerView)
 
        self.containerView.addSubview(positionNameLabel)
        self.positionNameLabel.constraint(top: containerView.topAnchor,
                                     leading: containerView.leadingAnchor,
                                     trailing: containerView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 75))
    }
    
    private func setupMainLabelLayout() {
        self.containerView.addSubview(mainLabel)
        self.mainLabel.constraint(leading: containerView.leadingAnchor,
                             bottom: containerView.bottomAnchor,
                             padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
    
    private func setupDeleteButtonLayout() {
        self.containerView.addSubview(deleteButton)
        self.deleteButton.constraint(top: containerView.topAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
    
    private func applySelectedState() {
        self.containerView.backgroundColor = isSelected ? .activeGradationPurple : .dark01
        self.containerView.layer.borderColor = isSelected ? UIColor.mainPurple.cgColor : UIColor.white.cgColor
    }
    
    func configure(data: Position) {
        self.positionImageView.image = UIImage(named: data.instrumentImageName)
        self.positionNameLabel.text = data.instrumentName
    }
}
