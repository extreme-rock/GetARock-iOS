//
//  CommentTableViewCell.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit

// MARK: - NotifyTapMoreButtonDelegate

protocol NotifyTapMoreButtonDelegate: AnyObject {
    func notifyTapMoreButton(cell: UITableViewCell, commentData: CommentList?)
}

// MARK: - class UITableViewCell

final class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: NotifyTapMoreButtonDelegate?
    private var cellIndex: Int = 0
    private var commentID: Int = 0
    private var memberName = ""
    private var commentData: CommentList? = nil
    
    // MARK: - View
    
    private let bandNameLabel = BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let moreButton: UIButton = {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let commentTextLabel: BasicLabel = {
        $0.numberOfLines = 0
        return $0
    }(BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white)
    )
    
    private let commentDateLabel = BasicLabel(
        contentText: "",
        fontStyle: .caption,
        textColorInfo: .gray02
    )
    
    private lazy var commentInfoStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel, moreButton]))
    
    private lazy var commentStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView(arrangedSubviews: [commentInfoStackView, commentTextLabel, commentDateLabel]))
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.contentView.addSubview(commentStackView)
        commentStackView.constraint(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 15, bottom: 40, right: 15)
        )
    }
    
    func configure(data: CommentList?, index: Int) {
        guard let comment = data else { return }
        self.commentData = comment
        self.cellIndex = index
        self.bandNameLabel.text = comment.memberName
        self.commentTextLabel.text = comment.comment
        self.commentDateLabel.text = comment.createdDate
    }
    
    @objc func showActionSheet() {
        self.delegate?.notifyTapMoreButton(cell: self, commentData: self.commentData)
    }
}

// MARK: - UITableViewHeaderFooterView

final class EmptyTableViewHeader: UITableViewHeaderFooterView {
    
    //MARK: - view
    
    private let emptyCommentLabel = BasicLabel(
        contentText: "댓글이 없습니다.",
        fontStyle: .content,
        textColorInfo: .gray02
    )
    
    // MARK: - init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.contentView.addSubview(emptyCommentLabel)
        emptyCommentLabel.constraint(
            top: contentView.topAnchor,
            centerX: contentView.centerXAnchor,
            padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        )
    }
}
