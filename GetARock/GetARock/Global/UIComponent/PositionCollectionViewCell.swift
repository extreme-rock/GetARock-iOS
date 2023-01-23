//
//  PositionCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/21.
//

import UIKit

final class PositionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    // MARK: - View
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        label.font = .systemFont(ofSize: 18, weight: .bold)
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
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - method
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.constraint(to: contentView)
        containerView.constraint(.widthAnchor, constant: 172)
        containerView.constraint(.heightAnchor, constant: 138)
        
        containerView.addSubview(positionImageView)
        positionImageView.constraint(to: containerView)
        
        containerView.addSubview(positionNameLabel)
        positionNameLabel.constraint(top: containerView.topAnchor,
                                     leading: containerView.leadingAnchor,
                                     trailing: containerView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 75))
    }
    
    func configure(data: Position) {
        self.positionImageView.image = UIImage(named: data.imageName)
        self.positionNameLabel.text = data.instrumentName
    }
    
    private func setupDeleteButtonLayout() {
        containerView.addSubview(deleteButton)
        deleteButton.constraint(top: containerView.topAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
}
