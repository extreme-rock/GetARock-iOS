//
//  BandMemeberCollectionViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/24.
//

import UIKit

final class BandMemberCollectionViewCell: UICollectionViewCell {

    // MARK: - View
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark02
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.gray02.cgColor
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
        label.font = UIFont.setFont(.headline01)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let linkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.arrowUpRightSymbol, for: .normal)
        button.tintColor = .mainPurple
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
    
    //MARK: - Life Cycle
    override func prepareForReuse() {
        let instrumentStackSubViews = self.informationStackView.arrangedSubviews
        instrumentStackSubViews.forEach {
            self.informationStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }   
    }
    
    //MARK: - Method
    
    private func setupLayout() {
        self.contentView.addSubview(containerView)
        self.containerView.constraint(to: contentView)
        self.containerView.constraint(.heightAnchor, constant: 138)
        
        self.containerView.addSubview(positionImageView)
        self.positionImageView.constraint(to: containerView)
 
        self.containerView.addSubview(memberNameLabel)
        self.memberNameLabel.constraint(top: containerView.topAnchor,
                                     leading: containerView.leadingAnchor,
                                     trailing: containerView.trailingAnchor,
                                     padding: UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 75))
        
        self.containerView.addSubview(informationStackView)
        self.informationStackView.constraint(top: memberNameLabel.bottomAnchor,
                                        leading: containerView.leadingAnchor,
                                        trailing: containerView.trailingAnchor,
                                        padding: UIEdgeInsets(top: 3, left: 15, bottom: 0, right: 101))
    }

    private func setupLinkButtonLayout() {
        self.containerView.addSubview(linkButton)
        self.linkButton.constraint(top: containerView.topAnchor,
                                trailing: containerView.trailingAnchor,
                                padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 15))
    }
    
    private func applyUserState(isUser: Bool) {
        self.containerView.backgroundColor = isUser ? .activeGradationPurple : .dark02
        self.containerView.layer.borderColor = isUser ? UIColor.mainPurple.cgColor : UIColor.gray02.cgColor
    }
    
    private func configureLeaderUI() {
        let imageConfiguation = UIImage.SymbolConfiguration(pointSize: 18)
        let crownImage = UIImageView()
        crownImage.image = ImageLiteral.crownSymbol
        crownImage.image?.withConfiguration(imageConfiguation)
        crownImage.tintColor = .white
        self.containerView.addSubview(crownImage)
        crownImage.constraint(top: containerView.topAnchor,
                              leading: memberNameLabel.trailingAnchor,
                              padding: UIEdgeInsets(top: 14, left: -5, bottom: 0, right: 0))
    }
    
    private func configureInstrumentNameUI(with instrumentNames: [String]) {
        instrumentNames.forEach { [weak self] in
            let label = UILabel()
            label.text = $0
            label.font = UIFont.setFont(.caption)
            label.textColor = .white
            self?.informationStackView.addArrangedSubview(label)
        }
    }
    
    func configure(data: BandMember) {
        self.positionImageView.image = UIImage(named: data.instrumentImageName.imageName)
        self.memberNameLabel.text = data.userName
        self.applyUserState(isUser: data.isUser)
        self.configureInstrumentNameUI(with: data.instrumentNames)
        
        if data.isUser {
            setupLinkButtonLayout()
        }
        
        if data.isLeader {
            configureLeaderUI()
        }
    }
}
