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
        contentText: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String,
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
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, latestVersionLabel]))
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: [leftStackView, currentVersionLabel]))
}
