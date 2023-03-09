//
//  AddPracticeSongViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/09.
//

import UIKit

final class AddPracticeSongViewController: BaseViewController {
    
    // MARK: - Property
    
    private var keyBoardHeight: CGFloat = 280
    
    // 정보 전달 클로저
    var completion: (_ songs: [PracticeSongCardView]) -> Void = { songs in }
    
    private var numberOfSong: Int = 1 {
        didSet {
            addPracticeSongButton.configuration?.title = "합주곡 추가\(numberOfSong)/3"
            addPracticeSongButton.configuration?.attributedTitle?.font = UIFont.setFont(.contentBold)
            if numberOfSong == 3 {
                addPracticeSongButton.isHidden = true
            } else {
                addPracticeSongButton.isHidden = false
            }
        }
    }
    
    // MARK: - View
    
    private let firstPracticeSongCard: PracticeSongCardView = PracticeSongCardView()
    
    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        let deleteAction: UIAction = UIAction { [weak self] _ in
            self?.deleteFirstPracticeSongCard()
        }
        firstPracticeSongCard.deleteButton.addAction(deleteAction, for: .touchUpInside)
        return $0
    }(UIStackView(arrangedSubviews: [firstPracticeSongCard]))
    
    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private lazy var addPracticeSongButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "합주곡 추가 \(numberOfSong)/3"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.backgroundColor = .dark02
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray02.cgColor
        button.constraint(.heightAnchor, constant: 50)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        return button
    }()
    
    private lazy var addCompleteButton: BottomButton = {
        $0.setTitle("추가", for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return $0
    }(BottomButton())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        setKeyboardDismiss()
        setNotificationObserver()
        setNavigationInlineTitle(title: "합주곡 추가")
    }
    
    override func viewDidLayoutSubviews() {
        updateDeleteButtonState()
    }
    
    // MARK: - deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Method
    
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
        
        mainScrollView.addSubview(addCompleteButton)
        
        addCompleteButton.constraint(top: addPracticeSongButton.bottomAnchor,
                                     leading: view.safeAreaLayoutGuide.leadingAnchor,
                                     trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                     padding: UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20))
    }
    
    private func updateDeleteButtonState() {
        if contentView.arrangedSubviews.count == 1 {
            contentView.arrangedSubviews.compactMap { $0 as? PracticeSongCardView }.forEach { $0.deleteButton.isHidden = true }
        } else {
            contentView.arrangedSubviews.compactMap { $0 as? PracticeSongCardView }.forEach { $0.deleteButton.isHidden = false }
        }
    }
    
    private func setKeyboardDismiss() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTouchScreen))
        mainScrollView.addGestureRecognizer(recognizer)
    }
    
    private func setNotificationObserver() {
        // 정보 입력에 따른 추가 버튼 상태 업데이트
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getKeyboardHeight(notification: )),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCompleteButtonState),
            name: Notification.Name.didPracticeCardViewTextFieldChange, object: nil
        )
    }
    
    private func deleteFirstPracticeSongCard() {
        UIView.animate(withDuration: 0.4, animations: {
            self.firstPracticeSongCard.alpha = 0 // fade out 애니메이션
        }, completion: { [weak self] _ in
            self?.firstPracticeSongCard.removeFromSuperview()
            self?.numberOfSong = self?.contentView.arrangedSubviews.count ?? 0
            UIView.animate(withDuration: 0.2) {
                self?.contentView.layoutIfNeeded() // StackView 레이아웃 재조정 애니메이션
            }
        })
    }
}

    // MARK: - objc func

extension AddPracticeSongViewController {
    
    @objc
    func didTapAddPracticeSong() {
        guard contentView.arrangedSubviews.count < 3 else { return }
        let newCard = PracticeSongCardView()
        newCard.setTextFieldDelegate(controller: self)
        
        let deleteAction: UIAction = UIAction { [weak self] _ in
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
        numberOfSong = contentView.arrangedSubviews.count // 카드뷰 숫자 업데이트
        NotificationCenter.default.post(name: Notification.Name.didPracticeCardViewTextFieldChange, object: nil) // 추가 버튼 활성화 여부 체크
        updateDeleteButtonState()
    }
    
    @objc
    func didTapCompleteButton() {
        let addedSongs: [PracticeSongCardView] = contentView.arrangedSubviews.compactMap { $0 as? PracticeSongCardView }
        completion(addedSongs)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTouchScreen() {
        self.view.endEditing(true)
    }
    
    @objc
    private func updateCompleteButtonState() {
        let isAllRequiredInfoFilled = contentView.arrangedSubviews
            .compactMap { $0 as? PracticeSongCardView }
            .filter { $0.getSongName().isEmpty || $0.getArtistName().isEmpty } // 정보가 하나라도 누락된 card만 필터링함
            .isEmpty // 정보가 누락되었는지 여부를 원소로 가지는 배열이 비어있다면, 모든 정보가 채워진 것임
        
        if isAllRequiredInfoFilled {
            addCompleteButton.isEnabled = true
        } else {
            addCompleteButton.isEnabled = false
        }
    }
    
    @objc
    func getKeyboardHeight(notification: Notification) {
        keyBoardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    }
}

    // MARK: - TextField Delegate

extension AddPracticeSongViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= self.keyBoardHeight
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y += self.keyBoardHeight
    }
}

