//
//  NotificationListViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationListViewController: UITableViewController {

    private var alertListData: [NotificationInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        fetchAlertListData()
    }
    
    private func attribute() {
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.classIdentifier)
        self.tableView.backgroundColor = .dark01
        self.tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.classIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.configure(with: alertListData[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .dark01
        let rejectAction = UIAction { _ in self.rejectInvitation() }
        cell.rejectButton.addAction(rejectAction, for: .touchUpInside)
        //MARK: Test 코드, 추후 isInvitation case 분기처리 필요
        if indexPath.row == 0 { cell.buttonHstack.isHidden = false }
        

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.alertListData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
//        let invitationIndexList: [Int] = alertListData.enumerated().filter { $1.isInvitation == true }.map { $0.offset }
//        if invitationIndexList.contains(indexPath.row) {
//            return 150
//        }
//
        return 100
    }
}

extension NotificationListViewController {
    //TODO: 추후 테스트 API는 삭제하고 다른 API로 대체해야함
    private func fetchAlertListData() {
        Task {
            do {
                guard let url = URL(string: "http://43.201.55.66:8080/alerts/test") else { throw NetworkError.badURL }

                let (data, response) = try await URLSession.shared.data(from: url)
                let httpResponse = response as! HTTPURLResponse

                if (200..<300).contains(httpResponse.statusCode) {
                    let decodedData = try JSONDecoder().decode(NotificationListDTO.self, from: data)
                    self.alertListData = decodedData.alertList
                } else {
                    throw NetworkError.failedRequest(status: httpResponse.statusCode)
                }
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
        let actionTitle = NSLocalizedString("확인", comment: "Alert OK button title")
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            self.dismiss(animated: true)}))
        present(alert, animated: true, completion: nil)
    }
}

