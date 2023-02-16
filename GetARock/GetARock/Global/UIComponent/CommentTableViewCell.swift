//
//  CommentTableViewCell.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/15.
//

import UIKit

// MARK: - UITableViewCell

final class CommentTableViewCell: UITableViewCell {
    
    private var cellIndex: Int = 0
    
    // MARK: - View
    
    private let bandNameLabel = BasicLabel(
        contentText: "",
        fontStyle: .headline01,
        textColorInfo: .white
    )
    
    private let moreButton: UIButton = {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .white
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
    
    let commentDateLabel = BasicLabel(
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
            padding: UIEdgeInsets(top: 0, left: 15, bottom: 30, right: 15)
        )
    }
    
    func configure(data: CommentList?, index: Int) {
        
        guard let comment = data else { return }
        self.cellIndex = index
        
        self.bandNameLabel.text = comment.memberName
        self.commentTextLabel.text = comment.comment
        self.commentDateLabel.text = comment.createdDate
        
    }
}

// MARK: - UITableViewHeaderFooterView

class emptyTableViewHeader: UITableViewHeaderFooterView {
    
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
            padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        )
        emptyCommentLabel.constraint(centerX: contentView.centerXAnchor)
    }
}
