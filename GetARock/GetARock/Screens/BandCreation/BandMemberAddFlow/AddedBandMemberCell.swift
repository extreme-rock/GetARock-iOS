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
        view.backgroundColor = .purple
        return view
    }()
    private let itemLabel: UILabel = {
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:  Cell Resue Prepare
    override func prepareForReuse() {
    }

    // MARK: - Methods

    private func attribute() {
        backgroundContentView.layer.cornerRadius = 10
    }

    private func setupLayout() {
        contentView.addSubview(backgroundContentView)
        backgroundContentView.constraint(to: self)
        backgroundContentView.addSubview(itemLabel)
        itemLabel.constraint(
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

    func configure(data: MemberList) {
        itemLabel.text = data.name
        self.id = data.id
    }
}

