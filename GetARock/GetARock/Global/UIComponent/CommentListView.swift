//
//  CommentListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit

// MARK: - CheckCellIndexDelegate

protocol CheckCellIndexDelegate: AnyObject {
    func checkCellIndex(indexPath: IndexPath, commentData: CommentList?)
}

// MARK: - class CommentListView

final class CommentListView: UIView {
    
    // MARK: - Property
    
    private var commentData: [CommentList]?
    private var totalCommentNumber: Int = 0
    private let tableviewRefreshControl = UIRefreshControl()
    weak var delegate: CheckCellIndexDelegate?
    
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
        setTableviewRefresh()
        setCommentListLoadObserver()
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
            trailing: self.trailingAnchor
        )
        
        self.addSubview(commentWriteTextView)
        commentWriteTextView.constraint(
            top: commentStackView.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.classIdentifier
        )
        tableView.register(
            EmptyTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: EmptyTableViewHeader.classIdentifier
        )
    }
    
    private func setupTotalListNumberLabel() {
        guard let count = commentData?.count else { return }
        self.totalCommentNumber = count
        totalCommentNumberLabel.text = "총 \(totalCommentNumber)개"
    }
    
    private func setTableviewRefresh() {
        tableviewRefreshControl.addTarget(self, action: #selector(didScrollDownCommentTable(refresh:)), for: .valueChanged)
        tableviewRefreshControl.tintColor = .gray02
        self.tableView.refreshControl = tableviewRefreshControl
    }
    
    private func setCommentListLoadObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadList),
            name: NSNotification.Name.loadBandData,
            object: nil
        )
    }
    
    // MARK: - @objc
    
    @objc func didScrollDownCommentTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
            self.setupTotalListNumberLabel()
            refresh.endRefreshing()
        }
    }
    
    @objc func loadList(notification: NSNotification){
        let data = notification.userInfo?["data"] as? [CommentList]
        self.commentData = data
        self.tableView.reloadData()
        self.setupTotalListNumberLabel()
    }
}

// MARK: - UITableViewDelegate

extension CommentListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: EmptyTableViewHeader.classIdentifier
        ) as? EmptyTableViewHeader
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if totalCommentNumber <= 0 {
            return 40.0
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
        
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        cell.configure(data: commentData?[indexPath.row],
                       index: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CommentListView: NotifyTapMoreButtonDelegate {
    func notifyTapMoreButton(cell: UITableViewCell, commentData: CommentList?) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let commentData = commentData
        self.delegate?.checkCellIndex(indexPath: indexPath, commentData: commentData)
    }
}
