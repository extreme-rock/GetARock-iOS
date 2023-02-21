//
//  NotificationListViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/21.
//

import UIKit

final class NotificationListViewController: UITableViewController {

    private var alertListData: [AlertList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        fetchAlertListData()
    }

    private func attribute() {
        self.tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.classIdentifier)

        self.tableView.backgroundColor = .dark01
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.classIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.configure(titleLable: alertListData[indexPath.row].content, subtitleLabel: alertListData[indexPath.row].content, uploadTime: alertListData[indexPath.row].updatedDate, isInvitation: alertListData[indexPath.row].isInvitation)

        cell.backgroundColor = .dark01

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.alertListData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if alertListData[indexPath.row].isInvitation == true {
            return 150
        }

//        var indexPathList: [Int] = []
//        for (index, data) in alertListData.enumerated() {
//            if data.isInvitation == true {
//                indexPathList.append(index)
//            }
//        }
        return 100
    }
}

extension NotificationListViewController {
    //MARK: 추후 테스트 API는 삭제하고 다른 API로 대체해야함
    private func fetchAlertListData() {
        Task {
            do {
                guard let url = URL(string: "http://43.201.55.66:8080/alerts/test") else { throw NetworkError.badURL }

                let (data, response) = try await URLSession.shared.data(from: url)
                let httpResponse = response as! HTTPURLResponse

                if (200..<300).contains(httpResponse.statusCode) {
                    let decodedData = try JSONDecoder().decode(AlertListDTO.self, from: data)
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

    private func rejectInvitation(_ error: Error) {
        // Comment를 이용해서 localization할 때 각국언어로 바꿀 수 있다고함
        // 애플 공식 app tutorial에 나오길래 한번써봄
        let alertTitle = NSLocalizedString("초대 거절", comment: "Invitation reject title")
        let alertMessage = NSLocalizedString("밴드 ‘로젤리아’의 초대를 거절하시겠습니까?", comment: "Invitation reject message")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("확인", comment: "Alert OK button title")
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
            // 클로저는 프로퍼티나 메소드 사용을 용이하게 하기 위해 주변 프로퍼티를 캡처한다
            // 여기서 dismiss라는 함수는 어디서 왔을까? viewController를 상속하기 때문에 사용할 수 있는 함수이다.
            // 따라서 뷰컨이 메모리에 올라갈 경우 그 메모리를 참조해서 이 함수를 쓸 수 있는 것이다
            // 클래스는 힙영역에 저장되고, 클래스를 바탕으로 만들어지는 인스턴스는 스택 영역에 올라갑니다. 그리고 힙영역의 메모리 주소를 참조합니다
            // 클로저 내부에서는 클래스의 프로퍼티를 사용해야하기때문에 클래스를 참조하게 됩니다.
            // 그럼 인스턴스가 필요없어서 deallocate되는 경우, 클로저에서 얘를 강한 참조하고 있기 때문에 메모리에서 해제되지않습니다. 이 말은 다른 화면으로 전환되었음에도 불구하고, 이 함수 때문에 레퍼런스 카운트 1이 남아있다는 말입니다. ARC는 레퍼 카운트가 0이 되지않으면 메모리 해제를 하지않습니다. 따라서 메모리 누수가 발생ㄹ합니다
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

