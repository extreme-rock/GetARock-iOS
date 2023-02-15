//
//  SettingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/02/14.
//

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
        settingTableView.dataSource = self
        settingTableView.delegate = self
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
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.backgroundColor = .dark01
        cell.selectionStyle = .none

        return cell
    }

}
