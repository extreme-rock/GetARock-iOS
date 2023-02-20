//
//  EventStateLabel.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/14.
//

import UIKit

// MARK: - DeleteDdayLableDelegate

protocol DeleteDdayLabelDelegate: AnyObject {
    func deleteDdayLabel()
}

// MARK: - EventStateLabel class

final class EventStateLabel: UILabel {
    
    // MARK: - Property
    
    enum EventLabelType {
        case dDay
        case state
        case category
    }
    
    weak var delegate: DeleteDdayLabelDelegate?
    private var labelData: String
    private var days = 0
    private var eventLabelType: EventLabelType
    private var padding = UIEdgeInsets(top: 6.0, left: 10.0, bottom: 6.0, right: 10.0)
    
    // MARK: - Init
    
    init(type: EventLabelType, data: String) {
        self.eventLabelType = type
        self.labelData = data
        super.init(frame: .zero)
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override Method
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.font = UIFont.setFont(.caption)
        self.textAlignment = .center
        setEventStateLabel()
    }
    
    private func setActiveUI() {
        self.backgroundColor = .mainPurple.withAlphaComponent(0.3)
        self.layer.borderColor = UIColor.mainPurple.cgColor
        self.textColor = .lightPurple
        self.textAlignment = .center
    }
    
    private func setDisabledUI() {
        self.backgroundColor = .dark02
        self.layer.borderColor = UIColor.gray02.cgColor
        self.textColor = .white
        self.textAlignment = .center
    }
    
    private func calculateDday() {
        
        guard let eventDate = labelData.toDate() else {return}
        
        let calendar = Calendar.current
        let eventDay = calendar.dateComponents([.day], from: eventDate)
        let currentDay = calendar.dateComponents([.day], from: Date())
        
        guard let betweenDays = calendar.dateComponents([.day],
                                                        from: currentDay,
                                                        to: eventDay).day else { return }
        
        days = betweenDays
    }
    
    private func setEventStateLabel() {
        
        switch eventLabelType {
        case .dDay:
            calculateDday()
            if days >= 0 {
                setActiveUI()
                self.text = "D-\(days)"
            } else {
                self.delegate?.deleteDdayLabel()
            }
            
        case .state:
            if labelData == "READY" {
                setActiveUI()
                self.text = "모집중"
                
            } else if labelData == "OPEN" {
                setActiveUI()
                self.text = "진행중"
                
            } else if labelData == "CLOSE" {
                setDisabledUI()
                self.text = "완료"
                
            } else {
                setDisabledUI()
                self.text = "취소"
            }
            
        case .category:
            setActiveUI()
            if labelData == "BAND_RECRUITING" {
                self.text = "합공 밴드 모집"
            } else if labelData == "EVENT_PR" {
                self.text = "공연 홍보"
            } else {
                self.text = "기타"
                
            }
        }
    }
}
