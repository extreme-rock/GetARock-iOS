//
//  SettingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/02/14.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: - Property
    
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

