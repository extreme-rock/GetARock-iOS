//
//  DeleteBandNoticeView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/23.
//

import UIKit

final class DeleteBandNoticeView: UIView {
    private let titleLabel = BasicLabel(contentText: "밴드 해체 알림",
                                        fontStyle: .headline01,
                                        textColorInfo: .white)
    
    private let subTitleLabel = BasicLabel(contentText: "'블랙로즈'가 해체됨",
                                        fontStyle: .headline01,
                                           textColorInfo: .white)
    
    private let contentLabel = BasicLabel(
        contentText: "헤어짐은 새로운 만남이 있는 법!\n새로운 밴드를 만들거나\n밴드 초대를 받고 밴드에 가입해보세요!",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        
    }
    
    private func setupLayout() {
        
    }
}
