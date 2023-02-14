//
//  BasicBoxView.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/14.
//

import UIKit

final class BasicBoxView: UIView {

    var text: String = ""

    lazy var basicLabel = BasicLabel(contentText: text, fontStyle: .contentBold, textColorInfo: .white)

    var basicRightView: UIImageView = {
        let imageView = UIImageView()
        //MARK: 이미지 리터럴로 이전해야함
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    init(text: String? = nil) {
        if let text = text { self.text = text }
        super.init(frame: .zero)
    }
    
    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .dark02
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: BasicComponentSize.width)
        self.constraint(.heightAnchor, constant: 55)
        
        addSubview(basicLabel)
        basicLabel.constraint(leading: self.leadingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        basicRightView.isHidden = true
        
        addSubview(basicRightView)
        basicRightView.constraint(.widthAnchor, constant: 15)
        basicRightView.constraint(.heightAnchor, constant: 15)
        basicRightView.constraint(trailing: self.trailingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
