//
//  AddedBandMemberCell.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class AddedBandMemberCell: UICollectionViewCell, Identifiable {

    // MARK: - properties
    var id: String = "default"

    private let backgroundContentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.applyMainGradient()
        return view
    }()
    
    private let addedMemberLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        return label
    }()

    lazy var deleteButton: UIButton = {
        $0.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)),
            for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 500),
                                     for: .horizontal)
        $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760),
                                                   for: .horizontal)
        return $0
    }(UIButton(type: .custom))

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        setupLayout()
    }

    override func setNeedsLayout() {
        self.backgroundContentView.applyActiveGradation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func attribute() {
        self.backgroundContentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderColor = UIColor.mainPurple.cgColor
    }

    private func setupLayout() {
        contentView.addSubview(backgroundContentView)
        backgroundContentView.constraint(to: self)
        backgroundContentView.addSubview(addedMemberLabel)
        addedMemberLabel.constraint(
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            centerY: self.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))

        backgroundContentView.addSubview(deleteButton)
        deleteButton.constraint(.widthAnchor, constant: 25)
        deleteButton.constraint(.heightAnchor, constant: 25)
        deleteButton.constraint(trailing: backgroundContentView.trailingAnchor,
                                centerY: backgroundContentView.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10))
    }

    func configure(data: SearchedUserInfo) {
        addedMemberLabel.text = data.name
        self.id = data.id
    }
}

