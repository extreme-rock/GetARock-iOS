//
//  ActiveGradationButton.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/25.
//

import UIKit

final class ActiveGradationButton: UIButton {

    // deactive 버튼을 어떻게 처리할까? 새로 button을 만들까, 이 button에서
    // enabled 값을 입력 받아서 ui를 다르게 처리할까.
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.setFont(.contentBold)
        setTitleColor(.white, for: .normal)
    }
}
