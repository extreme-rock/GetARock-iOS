//
//  ConsecutiveHstack.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/01.
//

import UIKit

struct TwoConsecutiveLabel {
    
    // 텍스트 필드 내 텍스트를 중복 확인 검사하는 경우 하단에 표기되는 레이블
    static var checkLabel: UIStackView = {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "checkmark.circle")!
            imageView.tintColor = .systemBlue
            imageView.constraint(.widthAnchor, constant: 20)
            imageView.constraint(.heightAnchor, constant: 20)
            return imageView
        }()
        
        let label = BasicLabel(contentText: "사용 가능해요", fontStyle: .caption, textColorInfo: .systemBlue)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
}
