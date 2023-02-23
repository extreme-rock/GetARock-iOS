//
//  SettingViewDefaultCell.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/02/21.
//

import UIKit

final class SettingViewDefaultCell: UITableViewCell {
    
    // MARK: - Property
    
    private let titleLabel = BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white
    )
    
    private let linkIcon: UIImageView = {
        $0.image = ImageLiteral.chevronRightSymbol
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .gray02
        return $0
    }(UIImageView())
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, linkIcon]))
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.selectionStyle = .none
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.contentView.addSubview(horizontalStackView)
        self.horizontalStackView.constraint(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 18, left: 16, bottom: 18, right: 16)
        )
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
