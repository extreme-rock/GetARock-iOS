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
    
    struct Option {
      let title: String
      let handler: () -> Void
    }
    
    private var options = [Option]()
    
    private lazy var settingTableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(SettingViewVersionCell.self, forCellReuseIdentifier: SettingViewVersionCell.classIdentifier)
        $0.backgroundColor = .dark01
        return $0
    }(UITableView())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLayout()
        configureModels()
    }
    
    // MARK: - Method
    
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
            trailing: self.view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
    }

}

// MARK: - Table Cell Method

extension SettingViewController {
    private func configureModels() {
        options.append(Option(title: "알림 설정", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToNotificationSetting()
            }
        }))
        
        options.append(Option(title: "약관 및 정책", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToPrivacyPolicy()
            }
        }))
        
        options.append(Option(title: "문의하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.sendReportMail()
            }
        }))
        
        options.append(Option(title: "서드파티 정보", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToThirdPartyInfo()
            }
        }))
        
        options.append(Option(title: "버전 정보", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.getVersionInfo()
            }
        }))
        
        options.append(Option(title: "로그아웃", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToLogOut()
            }
        }))
        
        options.append(Option(title: "탈퇴하기", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.goToDeleteAccount()
            }
        }))
    }
    
    private func goToNotificationSetting() {

    }
    
    private func goToPrivacyPolicy() {
        let notionURL = NSURL(string: "https://fascinated-neem-285.notion.site/907e9564134e4bbfa1b026324e85339d")
        let notionSafariView: SFSafariViewController = SFSafariViewController(url: notionURL! as URL)
        self.present(notionSafariView, animated: true, completion: nil)
    }
    
    private func goToThirdPartyInfo() {
        let notionURL = NSURL(string: "https://fascinated-neem-285.notion.site/72e315a117dd402aa5056cb4244b7f43")
        let notionSafariView: SFSafariViewController = SFSafariViewController(url: notionURL! as URL)
        self.present(notionSafariView, animated: true, completion: nil)
    }
    
    private func getVersionInfo() {
        
    }
    
    private func goToLogOut() {

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
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingViewVersionCell.classIdentifier,
                for: indexPath
            ) as! SettingViewVersionCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
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
            let aenittoEmail = "ryomyomyom@gmail.com"
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
            composeVC.setToRecipients([aenittoEmail])
            composeVC.setSubject("[문의 사항]")
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
