//
//  CommentListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit

final class CommentListView: UIView {

    // MARK: - Property
    
    enum CommentType {
        case bandComment
        case eventComment
    }
    
    private var commentType: CommentType
    
    // MARK: - View
    
    private let totalComentNumber = BasicLabel(contentText: "",
                                               fontStyle: .headline02,
                                               textColorInfo: .white)
    
    let tableView = {
        $0.backgroundColor = .dark01
        $0.showsVerticalScrollIndicator = false
        $0.separatorColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        return $0
    }(UITableView())

    private lazy var commentStackView: UIStackView = {
        $0.spacing = 20
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView(arrangedSubviews: [totalComentNumber, tableView]))

    
    // MARK: - Life Cycle
    
    init(type: CommentType) {
        self.commentType = type
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
        setupTotalListNumberLabel()
        setTableView()
    }
    
    private func setupLayout() {
        self.addSubview(commentStackView)
        commentStackView.constraint(to:self)
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.classIdentifier
        )
    }
    
    func setupTotalListNumberLabel() {
        switch commentType {
        case .bandComment:
            totalComentNumber.text = "총 개"
        case .eventComment:
            totalComentNumber.text = "총 개"
        }
    }
}

// MARK: - UITableViewDelegate

extension CommentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

// MARK: - UITableViewDataSource

extension CommentListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.indexPath(for: UITableViewCell())
        
        switch commentType {
        case .bandComment :
            return 3
        case .eventComment:
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.classIdentifier,
            for: indexPath
        ) as? CommentTableViewCell
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none

        switch commentType {
        case .bandComment:
            print("good")
        case .eventComment :
            print("good")
        }
        return cell
    }
}
