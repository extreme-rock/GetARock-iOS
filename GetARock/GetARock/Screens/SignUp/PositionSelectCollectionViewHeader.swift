//
//  SelectPositionHeaderView.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/01.
//

import UIKit

final class PositionSelectCollectionViewHeader: UIView {
    
    //MARK: - View
    
    private let pageIndicatorLabel: UILabel = {
        $0.font = .setFont(.subTitle)
        $0.text = "1/2"
        $0.textColor = .gray02
        return $0
    }(UILabel())
    
    private let titleLabel: UILabel = {
        $0.font = .setFont(.largeTitle01)
        $0.text = "할 수 있는 포지션을\n모두 알려주세요"
        $0.textColor = .white
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = .setFont(.subTitle)
        $0.text = "처음 선택한 악기가\n나의 Main 포지션이 됩니다."
        $0.textColor = .gray02
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var deselectAllPositionButton: UIButton = {
        $0.setTitle("전체 선택 해제", for: .normal)
        $0.setTitleColor(.gray02, for: .normal)
        $0.titleLabel?.font = .setFont(.content)
        $0.isHidden = true
        let action = UIAction { _ in
            self.postDeselectAllPosition()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        addObserveHideDeselectAllPositionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Method
    
    private func addObserveHideDeselectAllPositionButton() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideDeselectButton),
            name: Notification.Name.hideDeselectAllPositionButton,
            object: nil)
    }
    
    @objc
    private func hideDeselectButton() {
        self.deselectAllPositionButton.isHidden.toggle()
    }
    
    private func setupLayout() {
        self.addSubview(pageIndicatorLabel)
        pageIndicatorLabel.constraint(top: self.topAnchor,
                                      leading: self.leadingAnchor,
                                      trailing: self.trailingAnchor,
                                      padding: UIEdgeInsets(top: 20, left: 1, bottom: 0, right: 0))
        
        self.addSubview(titleLabel)
        titleLabel.constraint(top: pageIndicatorLabel.bottomAnchor,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor,
                              padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0))
        
        self.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        self.addSubview(deselectAllPositionButton)
        deselectAllPositionButton.constraint(top: subTitleLabel.bottomAnchor,
                                             bottom: self.bottomAnchor,
                                             trailing: self.trailingAnchor,
                                             padding: UIEdgeInsets(top: 15, left: 0, bottom: 11, right: 0))
    }
    
    private func postDeselectAllPosition() {
        NotificationCenter.default.post(
            name: Notification.Name.deselectAllPosition,
            object: nil)
    }
}
