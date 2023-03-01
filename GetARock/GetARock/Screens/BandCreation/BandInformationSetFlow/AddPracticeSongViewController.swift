//
//  AddPracticeSongViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/27.
//

import UIKit

final class AddPracticeSongViewController: BaseViewController {
    
    private var keyBoardHeight: CGFloat = 280
    
    var completion: (_ songs: [PracticeSongCardView]) -> Void = { songs in }
    
    private var numberOfSong: Int = 1 {
        didSet {
            addPracticeSongButton.configuration?.title = "합주곡 추가\(numberOfSong)/3"
            addPracticeSongButton.configuration?.attributedTitle?.font = UIFont.setFont(.contentBold)
            if numberOfSong == 3 {
                addPracticeSongButton.isEnabled = false
            } else {
                addPracticeSongButton.isEnabled = true
            }
        }
    }
    
    private let firstPracticeSongCard: PracticeSongCardView = PracticeSongCardView()
    
    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        let deleteAction: UIAction = UIAction { [weak self]_ in
            UIView.animate(withDuration: 0.4, animations: {
                self?.firstPracticeSongCard.alpha = 0 // fade out 애니메이션
            }, completion: { [weak self] _ in
                self?.firstPracticeSongCard.removeFromSuperview()
                self?.numberOfSong = self?.contentView.arrangedSubviews.count ?? 0
                UIView.animate(withDuration: 0.2) {
                    self?.contentView.layoutIfNeeded() // StackView 레이아웃 재조정 애니메이션
                }
            })
        }
        firstPracticeSongCard.deleteButton.addAction(deleteAction, for: .touchUpInside)
        return $0
    }(UIStackView(arrangedSubviews: [firstPracticeSongCard]))
    
    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private lazy var addPracticeSongButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "합주곡 추가 \(numberOfSong)/3"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        
        let button = DefaultButton(configuration: configuration)
        button.setBackgroundColor(.dark04, for: .disabled)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        setKeyboardDismiss()
        setNotification()
    }
    
    override func viewDidLayoutSubviews() {
        updateDeleteButtonState()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        
        view.addSubview(mainScrollView)
        
        mainScrollView.constraint(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor)
        
        mainScrollView.addSubview(contentView)

        // contentView는 stackView라서 높이정보가 자동으로 세팅됨
        // 따라서 스크롤범위를 맞추기위해 contentView의 하단 constraint가 필요함
        contentView.constraint(top: mainScrollView.contentLayoutGuide.topAnchor,
                               bottom: mainScrollView.contentLayoutGuide.bottomAnchor, centerX: mainScrollView.centerXAnchor,
                               padding: UIEdgeInsets(top: 20, left: 0, bottom: 160, right: 0))
        
        mainScrollView.addSubview(addPracticeSongButton)
        
        addPracticeSongButton.constraint(top: contentView.bottomAnchor,
                                         leading: contentView.leadingAnchor,
                                         trailing: contentView.trailingAnchor,
                                         padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        
        mainScrollView.addSubview(completeButton)
        
        completeButton.constraint(top: addPracticeSongButton.bottomAnchor,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                  padding: UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20))
    }
    
    private func updateDeleteButtonState() {
        //TODO: 강제언래핑 없애기
        if contentView.arrangedSubviews.count == 1 {
            contentView.arrangedSubviews.map { $0 as! PracticeSongCardView }.forEach { $0.deleteButton.isHidden = true }
        } else {
            contentView.arrangedSubviews.map { $0 as! PracticeSongCardView }.forEach { $0.deleteButton.isHidden = false }
        }
    }
    
    private func setKeyboardDismiss() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTouchScreen))
        mainScrollView.addGestureRecognizer(recognizer)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getKeyboardHeight(notification: )),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
}

extension AddPracticeSongViewController {
    @objc
    func didTapAddPracticeSong() {
        guard contentView.arrangedSubviews.count < 3 else { return }
        let newCard = PracticeSongCardView()
        newCard.setTextFieldDelegate(controller: self)
        let deleteAction: UIAction = UIAction { [weak self]_ in
            UIView.animate(withDuration: 0.4, animations: {
                newCard.alpha = 0 // fade out 애니메이션
            }, completion: { [weak self] _ in
                newCard.removeFromSuperview()
                self?.numberOfSong = self?.contentView.arrangedSubviews.count ?? 0
                UIView.animate(withDuration: 0.3) { // StackView 레이아웃 재조정 애니메이션
                    self?.contentView.layoutIfNeeded()
                }
            })
        }
        newCard.deleteButton.addAction(deleteAction, for: .touchUpInside)
        contentView.insertArrangedSubview(newCard, at: contentView.arrangedSubviews.endIndex)
        numberOfSong = contentView.arrangedSubviews.count
        updateDeleteButtonState()
    }
    
    @objc
    func didTapCompleteButton() {
        let addedSongs: [PracticeSongCardView] = contentView.arrangedSubviews.map { $0 as! PracticeSongCardView }
        completion(addedSongs)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTouchScreen() {
        self.view.endEditing(true)
    }
    
    @objc
    func getKeyboardHeight(notification: Notification) {
        keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}

extension AddPracticeSongViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= self.keyBoardHeight
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y += self.keyBoardHeight
    }
}
