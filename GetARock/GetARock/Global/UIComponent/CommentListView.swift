//
//  CommentListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit

// MARK: - CommentListView

final class CommentListView: UIView {
    
    private var commentData: [CommentList]?
    private var totalComentNumber: Int = 0
    
    // MARK: - View
    
    private let totalComentNumberLabel = BasicLabel(
        contentText: "총 0개",
        fontStyle: .headline02,
        textColorInfo: .white
    )
    
    private let tableView = {
        $0.backgroundColor = .dark01
        $0.showsVerticalScrollIndicator = false
        $0.separatorColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    private lazy var commentStackView: UIStackView = {
        $0.spacing = 20
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [totalComentNumberLabel, tableView]))
    
    private let commentwriteTextView = writeCommentTextView()
    
    // MARK: - Life Cycle
    
    init(data: [CommentList]?) {
        self.commentData = data
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
       }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
        setupTotalListNumberLabel()
        setTableView()
    }
    
    private func setupLayout() {
                self.addSubview(commentStackView)
//                commentStackView.constraint(to:self)
                commentStackView.constraint(top: self.topAnchor,
                                           leading: self.leadingAnchor,
                                           trailing: self.trailingAnchor,
                                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.addSubview(commentwriteTextView)
        commentwriteTextView.constraint(
            top: commentStackView.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0))
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.classIdentifier
        )
        tableView.register(emptyTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: emptyTableViewHeader.classIdentifier)
    }
    
    func setupTotalListNumberLabel() {
        guard let count = commentData?.count else { return }
        self.totalComentNumber = count
        totalComentNumberLabel.text = "총 \(totalComentNumber) 개"
    }
}

// MARK: - UITableViewDelegate

extension CommentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: emptyTableViewHeader.classIdentifier
        ) as? emptyTableViewHeader
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if totalComentNumber <= 0 {
            return 50.0
        } else {
            return 0.0
        }
    }
}

// MARK: - UITableViewDataSource

extension CommentListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.indexPath(for: UITableViewCell())
        return commentData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.classIdentifier,
            for: indexPath ) as? CommentTableViewCell
        else { return UITableViewCell()}
        
        cell.configure(data: commentData?[indexPath.row],
                       index: indexPath.row)
        return cell
    }
}

