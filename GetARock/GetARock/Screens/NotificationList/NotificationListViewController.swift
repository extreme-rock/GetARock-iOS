//
//  NotificationListViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationListViewController: UITableViewController {

    //MARK: - Property
    
    private var notificationList: [NotificationInfo] = []

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotificationList(with: UserDefaultStorage.memberID)
        attribute()
    }

    //MARK: - Method
    
    private func attribute() {
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.classIdentifier)
        self.tableView.backgroundColor = .dark01
        self.tableView.separatorStyle = .none
        
        self.setCustomBackButton()
        self.fixNavigationBarColorWhenScrollDown()
        self.setNavigationInlineTitle(title: "알림함")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.classIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }

        cell.configure(with: notificationList[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .dark01

        let rejectAction = UIAction { [weak self] _ in
            self?.rejectInvitation(cellIndexPath: indexPath)
        }

        let acceptAction = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(PositionSelectForInvitationViewController(),
                                                           animated: true)
        }
        
        cell.rejectButton.addAction(rejectAction, for: .touchUpInside)
        cell.acceptButton.addAction(acceptAction, for: .touchUpInside)
        return cell
    }
    
    //TODO: 추후 API 데이터로 변경 필요
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notificationList.count
    }
}

//MARK: - Extension

extension NotificationListViewController {
    private func fetchNotificationList(with memberID: Int) {
        Task {
            do {
                let serverData: [NotificationInfo] = try await NotificationNetworkManager.shared.getNotificationList(memberID: memberID)
                self.notificationList = serverData
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
    }
    
    private func rejectInvitation(cellIndexPath: IndexPath) {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = NSLocalizedString("초대 거절", comment: "Invitation reject title")
        let alertMessage = NSLocalizedString("밴드 ‘00 밴드’의\n초대를 거절하시겠습니까?", comment: "Invitation reject message")
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let rejectAction = NSLocalizedString("거절", comment: "Alert OK button title")
        let okayAction = NSLocalizedString("취소", comment: "Alert Cancel button title")

        alertController.addAction(UIAlertAction(title: okayAction, style: .default))
        alertController.addAction(UIAlertAction(title: rejectAction, style: .destructive, handler: { [weak self] _ in
            self?.tableView.performBatchUpdates {
                self?.reconfigureCellAfterRejectInvitation(cellIndexPath: cellIndexPath)
                //TODO: 추후 유저 정보로 query parameter 변경 필요
                NotificationNetworkManager.shared.rejectInvitation(alertId: 44, bandId: 32, memberId: 11)
            }
        }))
        present(alertController, animated: true)
    }
    
    private func reconfigureCellAfterRejectInvitation(cellIndexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: cellIndexPath) as? NotificationTableViewCell else { return }
        cell.buttonHstack.removeFromSuperview()
        //TODO: 추후 밴드 이름 파라미터 스트링 변경 필요
        cell.updateTextAfterRejectInvitation(bandName: "00밴드")
    }
    
    //TODO: 이 뷰를 들어온 사용자가, 자신이 초대한 사람이 거절을 했을 경우, 그에 맞게 UI 업데이트, 분기처리가 따로 필요함 (백엔드와 문의)
    private func getInvitationRejectNotification(cellIndexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: cellIndexPath) as? NotificationTableViewCell else { return }
        cell.updateTextForInvitationRejectAlert(userName: "알로라", bandName: "00밴드")
    }
}
