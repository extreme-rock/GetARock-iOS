//
//  Notification.Name+Extension.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/16.
//

import Foundation

extension Notification.Name {
    static let deletePositionCell = Notification.Name("deletePositionCell")
    static let showPositionPlusModal = Notification.Name("showPositionPlusModal")
    static let deselectAllPosition = Notification.Name("deselectAllPosition")
    static let hideDeselectAllPositionButton = Notification.Name("hideDeselectAllPositionButton")
    static let didTapPositionItem = Notification.Name("didTapPositionItem")
    static let loadBandData = NSNotification.Name("LoadBandData")
    static let didPracticeCardViewTextFieldChange = NSNotification.Name("didPracticeCardViewTextFieldChange")
    static let presentSNSSafariViewController = Notification.Name("presentSNSSafariViewController")
    static let presentSongSafariViewController = Notification.Name("presentSongSafariViewController")
    static let checkUnRegisteredCardViewInformationFilled = Notification.Name("checkUnRegisteredCardViewInformationFilled")
    static let checkRequiredBandInformationFilled = Notification.Name("checkRequiredBandInformationFilled")
    static let configureBandData = Notification.Name("configureBandData")
    static let presentLeaderPositionSelectViewController = Notification.Name("presentLeaderPositionSelectViewController")
    static let presentMypageDetailViewController = Notification.Name("presentMypageDetailViewController")
    static let presentBandDetailViewController = Notification.Name("presentBandDetailViewController")
    static let toggleNextButtonEnbaled = Notification.Name("toggleNextButtonEnbaled")
}
