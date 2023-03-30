//
//  SettingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/02/14.
//

import MessageUI
import SafariServices
import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
    private struct CellConfiguration {
      let title: String
      let handler: () -> Void
    }
    
    private var options = [CellConfiguration]()
    
    private lazy var settingTableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(SettingViewDefaultCell.self, forCellReuseIdentifier: SettingViewDefaultCell.classIdentifier)
        $0.register(SettingViewVersionCell.self, forCellReuseIdentifier: SettingViewVersionCell.classIdentifier)
        $0.backgroundColor = .dark01
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return $0
    }(UITableView())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLayout()
        configureModels()
        attribute()
    }
    
    // MARK: - Method

    private func attribute() {
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    private func setupLayout() {
        self.view.addSubview(self.settingTableView)
        self.settingTableView.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.safeAreaLayoutGuide.leadingAnchor,
            bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
            trailing: self.view.safeAreaLayoutGuide.trailingAnchor
        )
    }

}

// MARK: - Table Cell Method

extension SettingViewController {
    private func configureModels() {
        //TODO: 나중에 알림이 생기면 추가
//        options.append(CellConfiguration(title: "알림 설정", handler: { [weak self] in
//            DispatchQueue.main.async {
//                self?.goToNotificationSetting()
//            }
//        }))
        
        options.append(CellConfiguration(title: "약관 및 정책", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToPrivacyPolicy()
            }
        }))
        
        options.append(CellConfiguration(title: "문의하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.sendReportMail()
            }
        }))
        
        options.append(CellConfiguration(title: "서드파티 정보", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToThirdPartyInfo()
            }
        }))
        
        options.append(CellConfiguration(title: "버전 정보", handler: { [weak self] in
            // TODO: 앱스토어 연결
        }))
        
        options.append(CellConfiguration(title: "로그아웃", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.showAlertForLogout()
            }
        }))
        
        options.append(CellConfiguration(title: "탈퇴하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.sendAccountDeleteMail()
            }
        }))
    }
    
    private func goToNotificationSetting() {

    }
    
    private func goToPrivacyPolicy() {
        if let notionURL = NSURL(string: StringLiteral.privacyPolicyNotionURL) {
            let notionSafariView: SFSafariViewController = SFSafariViewController(url: notionURL as URL)
            self.present(notionSafariView, animated: true, completion: nil)
        }
    }
    
    private func goToThirdPartyInfo() {
        if let notionURL = NSURL(string: StringLiteral.thirdPartyInfoNotionURL) {
            let notionSafariView: SFSafariViewController = SFSafariViewController(url: notionURL as URL)
            self.present(notionSafariView, animated: true, completion: nil)
        }
    }

    private func showAlertForLogout() {
        let alertTitle = "로그아웃"
        let alertMessage = "정말 로그아웃 하시겠어요?"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let changeActionTitle = "로그아웃"
        let okayActionTitle = "취소"

        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .default))
        alertController.addAction(UIAlertAction(title: changeActionTitle, style: .destructive, handler: { _ in
            self.goToLogOut()
        }))
        present(alertController, animated: true)
    }
    
    private func goToLogOut() {
        UserDefaultHandler.clearAllData()
        DispatchQueue.main.async { [weak self] in
            let viewController = LandingViewController()
            self?.view.window?.rootViewController = viewController
        }
    }
    
    private func goToDeleteAccount() {
      
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 { return 70 }
        
        return 50
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = options[indexPath.row]
        if indexPath.row < 3 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewDefaultCell.classIdentifier,
                for: indexPath
            ) as? SettingViewDefaultCell else { return UITableViewCell() }
            cell.configure(title: model.title)
            
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewVersionCell.classIdentifier,
                for: indexPath
            ) as? SettingViewVersionCell else { return UITableViewCell() }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = .gray02
        cell.backgroundColor = .dark01
        cell.selectionStyle = .none
        
        return cell
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let getarockEmail = "ryomyomyom@gmail.com"
            // TODO: 유저디폴트에서 닉네임 가져오기
            let messageBody = """
                              
                              -----------------------------
                              
                              - 문의하는 닉네임:
                              - 문의 메시지 제목 한줄 요약:
                              - 문의 날짜: \(Date())
                              
                              ------------------------------
                              
                              문의 내용을 작성해주세요.
                              
                              """
            
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([getarockEmail])
            composeVC.setSubject("[문의 사항]")
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }

    func sendAccountDeleteMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let getarockEmail = "ryomyomyom@gmail.com"
            // TODO: 유저디폴트에서 닉네임 가져오기
            let messageBody = """

                              -----------------------------

                              - 문의하는 닉네임:
                              - 문의 날짜: \(Date())

                              ------------------------------

                              탈퇴 사유를 알려주실 수 있나요?

                              """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([getarockEmail])
            composeVC.setSubject("[탈퇴 하기]")
            composeVC.setMessageBody(messageBody, isHTML: false)

            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "메일 전송 실패",
            message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}
