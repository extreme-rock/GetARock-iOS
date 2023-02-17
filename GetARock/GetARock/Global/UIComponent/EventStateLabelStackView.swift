//
//  EventStateLabelStackView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/14.
//

import UIKit

final class EventStateLabelStackView: UIStackView {

    // MARK: - VIew
    
    private let eventData: Event
    private lazy var dDayLabel = EventStateLabel(type: .dDay,
                                                 data: eventData.startTime)
    private lazy var stateLabel = EventStateLabel(type: .state,
                                                  data: eventData.state.rawValue)
    private lazy var categoryLabel = EventStateLabel(type: .category,
                                                     data: eventData.category.rawValue)
    
    // MARK: - Init
    
    init(data: Event) {
        self.eventData = data
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func attribute() {
        self.axis = .horizontal
        self.spacing = 5
    }
    
    private func setupLayout() {
        self.addArrangedSubview(dDayLabel)
        self.addArrangedSubview(stateLabel)
        self.addArrangedSubview(categoryLabel)
    }
}

// MARK: - DeleteDdayLabelDelegate

extension EventStateLabelStackView: DeleteDdayLabelDelegate {
    func DeleteDdayLabel() {
        self.removeArrangedSubview(dDayLabel)
    }
}
