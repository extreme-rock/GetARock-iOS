//
//  SettingViewVersionCell.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/02/14.
//

import UIKit

class SettingViewVersionCell: UITableViewCell {
    
    // MARK: - Property

    private let titleLabel = BasicLabel(
        contentText: "버전 정보",
        fontStyle: .content,
        textColorInfo: .white
    )
    
    private lazy var latestVersionLabel = BasicLabel(
        // TODO: 테스트 플라이트 혹은 배포 후에 최신 버전 정보로 변경
        contentText: "최신버전: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)",
        fontStyle: .caption,
        textColorInfo: .gray02
    )
    
    private let currentVersionLabel = BasicLabel(
        contentText: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
        fontStyle: .content,
        textColorInfo: .mainPurple
    )
    
    private lazy var leftStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, latestVersionLabel]))
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [leftStackView, currentVersionLabel]))
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
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
}
