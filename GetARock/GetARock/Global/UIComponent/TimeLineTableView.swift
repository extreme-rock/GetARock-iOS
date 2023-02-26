//
//  TimeLineTableView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/26.
//

import UIKit

final class TimeLineTableView: UITableView {
    
    // MARK: - Property
    
    private var eventData: [Event]?
    
    // MARK: - View
    
    // MARK: - Init
    
    init(data: [Event]?) {
        self.eventData = data
        super.init(frame: CGRectZero, style: UITableView.Style.plain)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
        self.showsVerticalScrollIndicator = false
        self.separatorColor = .clear
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setupLayout() {
        //        self.addSubview(commentStackView)
        //        commentStackView.constraint(
        //            top: self.topAnchor,
        //            leading: self.leadingAnchor,
        //            trailing: self.trailingAnchor,
        //            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        )
        //
    }
    
    private func setTableView() {
        self.delegate = self
        self.dataSource = self
        self.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.classIdentifier
        )
        self.register(
            EmptyTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: EmptyTableViewHeader.classIdentifier
        )
    }
}

// MARK: - UITableViewDelegate

extension TimeLineTableView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension TimeLineTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
