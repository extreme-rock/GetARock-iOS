//
//  CommentListView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit


// MARK: - CommentListView

final class CommentListView: UIView {
    
    var commentData: [CommentList]? {
        didSet {
            
           
//            DispatchQueue.main.async {
//                //                let vc = BandDetailViewController()
//                //                vc.delegate = self
//                self.tableView.reloadData()
//                self.setupTotalListNumberLabel()
//            }
            
            // 추가하면 commentData에 댓글은 박히는데 테이블뷰 리로드가 안됨..ㅠㅠ
            DispatchQueue.main.async(execute: {
                print("🔥🚨🔥🚨테이블뷰 데이터🔥🚨🔥🚨: \(self.commentData)")
                print("🔥🚨🔥🚨테이블뷰 데이터🔥🚨🔥🚨: \(self.commentData?.count)")
                self.tableView.reloadData()
            })
        }
    }
    private var totalCommentNumber: Int = 0
    private let tableviewRefreshControl = UIRefreshControl()
    
    // MARK: - View
    
    //TODO: - 댓글 작성 POST 연동 후 didSet 처리 추가해야함!
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
        setTableView()
        initRefresh()
        //self.refreshCommentList(data: commentData)
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
//        setTableView()
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
            EmptyTableViewHeader.self,
            forHeaderFooterViewReuseIdentifier: EmptyTableViewHeader.classIdentifier
        )
    }
    
    private func setupTotalListNumberLabel() {
        guard let count = commentData?.count else { return }
        self.totalCommentNumber = count
        totalCommentNumberLabel.text = "총 \(totalCommentNumber)개"
    }
    
    func initRefresh() {
        tableviewRefreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        tableviewRefreshControl.tintColor = .gray02
        self.tableView.refreshControl = tableviewRefreshControl
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
            refresh.endRefreshing()
            self.setupTotalListNumberLabel()
        }
        print("새로고침 완료")
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
        
        cell.backgroundColor = UIColor.clear
        cell.configure(data: commentData?[indexPath.row],
                       index: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - CommentListUpdateDelegate
//
extension CommentListView: CommentListUpdateDelegate {
    func refreshCommentList(data: [CommentList]?) {
//        self.commentData = data
//        print("🔥🚨🔥🚨델리게이트 일하고 있습니다~🔥🚨🔥🚨 \(self.commentData)")
        //        DispatchQueue.main.async { [weak self] in
        //            print("🔥🚨🔥🚨델리게이트 일하고 있습니다~🔥🚨🔥🚨")
        //            self?.tableView.reloadData()
        //            self?.setupTotalListNumberLabel()
        //        }
    }
}
