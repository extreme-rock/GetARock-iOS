//
//  CommentTextView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/16.
//

import UIKit
//
//protocol CommentListUpdateDelegate: AnyObject {
//    func refreshCommentList()
//}

final class WriteCommentTextView: UIView {
    
    // MARK: - Property
    
//    weak var delegate: CommentListUpdateDelegate?
    private let maxHeight: CGFloat = 116
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var keyboardHeightPaddingConstraint: NSLayoutConstraint?
    private var keyboardHeight: CGFloat = 30
    
    //TODO: 멤버아이디랑 밴드ID는 로그인한 사용자 정보를 가져와서 사용해야함
    private var memberId = "10"
    private var bandId = "1"
    private var contentText = ""
//    private lazy var postcomment = CommentListDTO(memberId: memberId, bandId:  bandId, content: "댓글 포스트 성공")
    
    // MARK: - View
    
    private lazy var commentTextView: UITextView = {
        $0.font = UIFont.setFont(.content)
        $0.backgroundColor = .dark02
        $0.textColor = .white
        $0.isScrollEnabled = false
        $0.delegate = self
        return $0
    }(UITextView())
    
    private lazy var addCommentButton: DefaultButton = {
        $0.setTitle("등록", for: .normal)
        $0.addTarget(self, action:  #selector(TapAddCommentButton), for: .touchUpInside)
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
    
    private let keyboardHeightPaddingView: UIView = {
        return $0
    }(UIView())
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        attribute()
        setupLayout()
        setKeyboardObserver()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark02
        self.addTopBorder(color: .gray02, borderWidth: 0.5)
    }
    
    private func setupLayout() {
        
        self.addSubview(contentView)
        contentView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16)
        )
        
        self.addSubview(keyboardHeightPaddingView)
        keyboardHeightPaddingView.constraint(
            top:  contentView.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        setKeyBoardHeightPaddingConstraint()
        
        self.contentView.addSubview(commentTextView)
        commentTextView.constraint(
            top: self.contentView.topAnchor,
            leading: self.contentView.leadingAnchor,
            bottom: self.contentView.bottomAnchor,
            trailing: self.contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 80)
        )
        setTextViewHeightConstraint()
        
        self.contentView.addSubview(addCommentButton)
        addCommentButton.constraint(
            leading: commentTextView.trailingAnchor,
            bottom: self.contentView.bottomAnchor,
            trailing: self.contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        )
        addCommentButton.constraint(.heightAnchor, constant: 40)
        addCommentButton.isHidden = true
        
        setPlaceholderLabelLayout()
    }
    
    private func setTextViewHeightConstraint() {
        textViewHeightConstraint = commentTextView.heightAnchor.constraint(
            equalToConstant: 35
    )
        textViewHeightConstraint?.isActive = true
    }
    
    private func setKeyBoardHeightPaddingConstraint() {
        keyboardHeightPaddingConstraint = keyboardHeightPaddingView.heightAnchor.constraint(
            equalToConstant: 40
        )
        keyboardHeightPaddingConstraint?.isActive = true
    }
    
    private func setPlaceholderLabelLayout() {
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
            textViewHeightConstraint?.constant = newSize.height + 2
        }
    }
    
    @objc func TapAddCommentButton() {
        print("🔥버튼눌림🔥")
        if self.commentTextView.text.isEmpty == false {
            self.contentText = commentTextView.text
            postComment()
            self.commentTextView.text.removeAll()
        }
        
    }
}

// MARK: - UITextViewDelegate

extension WriteCommentTextView: UITextViewDelegate {
    
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

// MARK: - Keyboard NotificationCenter

extension WriteCommentTextView {
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object:nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.keyboardHeightPaddingConstraint?.constant = self.keyboardHeight + 10
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.keyboardHeightPaddingConstraint?.constant = 40
    }
}

// MARK: - Post Comment

extension WriteCommentTextView {
    
    func postComment() {
        do {
            let headers = [
                "Authorization": "Bearer " + "token",
                "accept": "application/json",
                "Notion-Version": "2022-06-28",
                "content-type": "application/json"
            ]
            
            var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/comment/band")
            let memberIdQuery = URLQueryItem(name: "memberId", value: memberId)
            let bandIdQuery = URLQueryItem(name: "bandId", value: bandId)
            let content = URLQueryItem(name: "content", value: contentText)
            queryURLComponent?.queryItems = [memberIdQuery,bandIdQuery,content]
            
            guard let url = queryURLComponent?.url else { return }
            let request = NSMutableURLRequest(url: url,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            Task {
                await BandDetailViewController().getBandData()
            }

            let dataTask = URLSession.shared.dataTask(with: request as URLRequest,
                                                      completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("통신 과정에서 에러가 났습니다.")
                    print(error?.localizedDescription ?? "error case occured")
                } else {
                    print("response는 다음과 같습니다")
                    print(response)
                }
            })
            dataTask.resume()
        }
    }
}
