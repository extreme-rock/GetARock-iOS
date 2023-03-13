//
//  BandSelectToggleTableViewCell.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/09.
//

import UIKit

final class BandSelectMenuTableViewCell: UITableViewCell {
    
    // MARK: - View
    
    private lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 46 
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        $0.backgroundColor = .dark03
       return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel, checkImageView]))
    
    private let bandNameLabel: UILabel = {
        $0.font = .setFont(.headline04)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return $0
    }(UILabel())
    
    private let checkImageView: UIImageView = {
        $0.tintColor = .gray02
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.image = ImageLiteral.circleSymbol
        return $0
    }(UIImageView())
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.checkImageView.image = selected ? ImageLiteral.checkMarkCircleFillSymbol : ImageLiteral.circleSymbol
        self.checkImageView.tintColor = selected ? .mainPurple : .gray02
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView)
        stackView.constraint(to: self.contentView)
        stackView.constraint(.widthAnchor, constant: 250)
    }
    
    func configure(with name: String) {
        self.bandNameLabel.text = name
    }
}
