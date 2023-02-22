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
    private var totalCommentNumber: Int = 0
    
    // MARK: - View
    
    private let totalCommentNumberLabel = BasicLabel(
        contentText: "총 0개",
        fontStyle: .content,
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
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
        return $0
    }(UIStackView(arrangedSubviews: [totalCommentNumberLabel, tableView]))
    
    private let commentWriteTextView = WriteCommentTextView()
    
    // MARK: - Life Cycle
    
    init(data: [CommentList]?) {
        self.commentData = data
        super.init(frame: .zero)
        attribute()
        setupLayout()
        let vc = BandDetailViewController()
        vc.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
        setupTotalListNumberLabel()
        setTableView()
    }
    
    private func setupLayout() {
        self.addSubview(commentStackView)
        commentStackView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        self.addSubview(commentWriteTextView)
        commentWriteTextView.constraint(
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
        tableView.register(
            emptyTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: emptyTableViewHeader.classIdentifier
        )
    }
    
    private func setupTotalListNumberLabel() {
        guard let count = commentData?.count else { return }
        self.totalCommentNumber = count
        totalCommentNumberLabel.text = "총 \(totalCommentNumber)개"
    }
}

// MARK: - UITableViewDelegate

extension CommentListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: emptyTableViewHeader.classIdentifier
        ) as? emptyTableViewHeader
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if totalCommentNumber <= 0 {
            return 50.0
        } else {
            return 0.0
        }
    }
}

// MARK: - UITableViewDataSource

extension CommentListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        tableView.indexPath(for: UITableViewCell())
        return commentData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.classIdentifier,
            for: indexPath ) as? CommentTableViewCell
        else { return UITableViewCell()}
        
        cell.configure(data: commentData?[indexPath.row],
                       index: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - CommentListUpdateDelegate

extension CommentListView: CommentListUpdateDelegate {
    func refreshCommentList(data: [CommentList]?) {
        commentData = data
        print("델리게이트 일하고 있습니다~")
        print("댓글 정보 이거 받았어요~ \(commentData)")
        self.tableView.reloadData()
        self.setupTotalListNumberLabel()
    }
}
