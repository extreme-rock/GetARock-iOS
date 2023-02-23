//
//  NotificationListViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationListViewController: UITableViewController {
    
    //TODO: 추후에 API를 통해 update 할 알람 리스트
    private var alertListData: [NotificationInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    private func attribute() {
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.classIdentifier)
        self.tableView.backgroundColor = .dark01
        self.tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.classIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.configure(with: NotificationListDTO.testData[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .dark01
        let rejectAction = UIAction { _ in self.rejectInvitation() }
        let acceptAction = UIAction { _ in
            //TODO: 초대 수락시 navigation Flow
        }
        cell.rejectButton.addAction(rejectAction, for: .touchUpInside)
        cell.acceptButton.addAction(acceptAction, for: .touchUpInside)
        //MARK: Test 코드, 추후 isInvitation case 분기처리 필요
        
        return cell
    }
    
    //TODO: 추후 API 데이터로 변경 필요
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NotificationListDTO.testData.count
    }
}

extension NotificationListViewController {
    //TODO: 추후 테스트 API는 삭제하고 다른 API로 대체해야함, viewDidload 과정에서 초기 데이터 세팅 과정 필요
    private func fetchAlertListData() {
        Task {
            do {
                let serverData: [NotificationInfo] = try await NetworkManager.shared.getNotificationList(memberId: 1)
                self.alertListData = serverData
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
    }
    
    private func rejectInvitation() {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = NSLocalizedString("초대 거절", comment: "Invitation reject title")
        let alertMessage = NSLocalizedString("밴드 ‘00 밴드’의 초대를 거절하시겠습니까?", comment: "Invitation reject message")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okayAction = NSLocalizedString("확인", comment: "Alert OK button title")
        let cancelAction = NSLocalizedString("취소", comment: "Alert Cancel button title")
        alert.addAction(UIAlertAction(title: cancelAction, style: .destructive))
        alert.addAction(UIAlertAction(title: okayAction, style: .default, handler: { [weak self] _ in
            self?.tableView.beginUpdates()
            self?.reconfigureCellAfterRejectInvitation()
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.tableView.endUpdates()
            })}))
        present(alert, animated: true, completion: nil)
    }
    
    private func getInvitationRejectNotification() {
        //TODO: 이 뷰를 들어온 사용자가, 자신이 초대한 사람이 거절을 했을 경우, 그에 맞게 UI 업데이트, 분기처리가 따로 필요함
        //MARK: 하지만 바로 양쪽 사용자 모두 업데이트 시키는게 쉽지않을듯? 초대한 사람이 결과를 업데이트 받으려면 나갓다오게 하는 걸로...
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NotificationTableViewCell else { return }
        cell.updateTextForInvitationRejectAlert(userName: "알로라", bandName: "00밴드")
    }
    
    private func reconfigureCellAfterRejectInvitation() {
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NotificationTableViewCell else { return }
        cell.buttonHstack.removeFromSuperview()
        cell.updateTextAfterRejectInvitation(bandName: "00밴드")
    }
}

