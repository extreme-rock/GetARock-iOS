//
//  PlusPositionViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/31.
//

import UIKit

class PlusPositionViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        $0.font = .setFont(.headline01)
        $0.text = "가능한 포지션을 추가해주세요"
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = .setFont(.caption)
        $0.text = "기타 포지션은 최대 공백 포함 10자까지 작성 가능합니다."
        $0.textColor = .white
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
