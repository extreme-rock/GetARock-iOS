//
//  CommentTextView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/16.
//

import UIKit

class writeCommentTextView: UIView {
    
    // MARK: - Property
    
    private let maxHeight: CGFloat = 116
    private let textStyle = NSMutableParagraphStyle()
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - View
    
    private lazy var commentTextView: UITextView = {
        textStyle.lineSpacing = CGFloat(10)
        $0.font = UIFont.setFont(.content)
        $0.backgroundColor = .dark02
        $0.textColor = .white
        $0.isScrollEnabled = false
        $0.delegate = self
        return $0
    }(UITextView())
    
    private let addCommentButton: DefaultButton = {
        $0.setTitle("등록", for: .normal)
        return $0
    }(DefaultButton())
    
    private let contentView: UIView = {
        return $0
    }(UIView())
    
    private let placeholderLabel: UILabel = BasicLabel(
        contentText: "댓글을 입력하세요",
        fontStyle: .content,
        textColorInfo: .gray02
    )
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        attribute()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark02
    }
    
    private func setupLayout() {
        self.addSubview(contentView)
        contentView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 16, bottom: 10, right: 16)
        )
        
        self.contentView.addSubview(commentTextView)
        commentTextView.constraint(
            top: self.contentView.topAnchor,
            leading: self.contentView.leadingAnchor,
            bottom: self.contentView.bottomAnchor,
            trailing: self.contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 80)
        )
        textViewHeightConstraint = commentTextView.heightAnchor.constraint(equalToConstant: 35)
        textViewHeightConstraint?.isActive = true
        
        self.contentView.addSubview(addCommentButton)
        addCommentButton.constraint(
            leading: commentTextView.trailingAnchor,
            bottom: self.contentView.bottomAnchor,
            trailing: self.contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
        addCommentButton.constraint(.heightAnchor, constant: 40)
        addCommentButton.isHidden = true
        
        setplaceholderLabelLayout()
    }
    
    private func setplaceholderLabelLayout() {
        self.addSubview(placeholderLabel)
        placeholderLabel.constraint(
            top: commentTextView.topAnchor,
            leading: commentTextView.leadingAnchor,
            padding: UIEdgeInsets(top: 8, left: 3, bottom: 0, right: 0)
        )
    }
    
    private func adjustTextViewHeight() {
        let fixedWidth = commentTextView.frame.size.width
        let newSize = commentTextView.sizeThatFits(
            CGSize(width: fixedWidth,
                   height: CGFloat.greatestFiniteMagnitude)
        )
        
        if newSize.height >= 116 {
            commentTextView.isScrollEnabled = true
        }
        else {
            commentTextView.isScrollEnabled = false
            textViewHeightConstraint?.constant = newSize.height
        }
    }
}

// MARK: - UITextViewDelegate

extension writeCommentTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
        addCommentButton.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addCommentButton.isHidden = true
            placeholderLabel.isHidden = false
        }
    }
}
