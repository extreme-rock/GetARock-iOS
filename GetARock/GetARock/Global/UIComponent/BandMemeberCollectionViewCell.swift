//
//  BandMemeberCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import UIKit

final class BandMemeberCollectionViewCell: UICollectionViewCell {

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
    
    private lazy var informationStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    private let memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let linkButton: UIButton = {
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
 
        containerView.addSubview(memberNameLabel)
        memberNameLabel.constraint(top: containerView.topAnchor,
                                     leading: containerView.leadingAnchor,
                                     trailing: containerView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 75))
        
        containerView.addSubview(informationStackView)
        informationStackView.constraint(top: memberNameLabel.bottomAnchor,
                                        leading: containerView.leadingAnchor,
                                        trailing: containerView.trailingAnchor,
                                        padding: UIEdgeInsets(top: 3, left: 15, bottom: 0, right: 101))
    }

    private func setupLinkButtonLayout() {
        containerView.addSubview(linkButton)
        linkButton.constraint(top: containerView.topAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
    
    private func applyUserState(isUser: Bool) {
        containerView.backgroundColor = isUser ? .activeGradationPurple : .black
        containerView.layer.borderColor = isUser ? UIColor.mainPurple.cgColor : UIColor.white.cgColor
    }
    
    func configure(data: BandMember) {
        self.positionImageView.image = UIImage(named: data.imageName)
        self.memberNameLabel.text = data.userName
        // 리더면 왕관 추가
        if data.isLeader {
            let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 18)
            let crownImage = UIImageView()
            crownImage.image = UIImage(systemName: "crown", withConfiguration: imageConfiguation)
            containerView.addSubview(crownImage)
            crownImage.constraint(top: containerView.topAnchor,
                                  leading: memberNameLabel.trailingAnchor,
                                  padding: UIEdgeInsets(top: 16, left: 2, bottom: 0, right: 0))
        }
        
        data.instrumentNames.forEach { [weak self] in
            let label = UILabel()
            label.text = $0
            self?.informationStackView.addArrangedSubview(label)
        }

    }

}
