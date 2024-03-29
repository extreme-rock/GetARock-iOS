//
//  AddUnRegisteredMemberViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/21.
//

import UIKit

//TODO: API 업데이트 되면 TableCell에 선택한 여러 악기가 표기 되게 만들기
final class AddUnRegisteredMemberViewController: BaseViewController {

    //MARK: - Property

    private var addedMembers: [SearchedUserInfo] = []

    var completion: (_ registeredMember: [SearchedUserInfo]) -> Void = { addedMembers in }

    private lazy var firstData: SearchedUserInfo = SearchedUserInfo(
        memberId: nil,
        name: firstUnRegisteredCard.nickNameTextField.textField.text ?? "",
        memberState: .annonymous,
        instrumentList: [SearchedUserInstrumentList(instrumentId: -1,
                                                    isMain: true,
                                                    name: firstUnRegisteredCard.otherPositionTextField.textField.text ?? "")], gender: "Unknown", age: "Unknown")

    //MARK: - View

    private lazy var firstUnRegisteredCard: UnRegisteredMemberCardView = {
        let card = UnRegisteredMemberCardView()
        let action = UIAction { _ in
            self.addedMembers.append(self.firstData)
            self.addedMembers.removeAll { $0.id == self.firstData.id }
        }
        card.deleteButton.addAction(action, for: .touchUpInside)
        return card
    }()

    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        return $0
    }(UIStackView(arrangedSubviews: [firstUnRegisteredCard]))

    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())

    private lazy var addPracticeSongButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "미가입 멤버 추가"
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
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("추가 완료", for: .normal)
        $0.isEnabled = false
        $0.addAction(addCompletionAction, for: .touchUpInside)
        return $0
    }(BottomButton())

    private lazy var addCompletionAction = UIAction { _ in
        for subview in self.contentView.arrangedSubviews {
            guard let card = subview as? UnRegisteredMemberCardView else { return }

            var instrumentList: [SearchedUserInstrumentList] = []

            let mainPosition: SearchedUserInstrumentList = SearchedUserInstrumentList(
                instrumentId: -1,
                isMain: true,
                name: card.positionSelectCollectionView.selectedItem() )

            instrumentList.append(mainPosition)

            if !card.otherPositionTextField.inputText().isEmpty {
                let otherPosition: SearchedUserInstrumentList = SearchedUserInstrumentList(
                    instrumentId: -1,
                    isMain: false,
                    name: card.otherPositionTextField.inputText())
                instrumentList.append(otherPosition)
            }
            
            let data = SearchedUserInfo(
                memberId: nil,
                name: card.nickNameTextField.textField.text ?? "",
                memberState: .annonymous,
                instrumentList: instrumentList,
                gender: "Unknown",
                age: "Unknown")
            self.addedMembers.append(data)
        }
        self.completion(self.addedMembers)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        setNotificationObserver()
    }

    override func viewDidLayoutSubviews() {
        applySnapshotForDeleteButton()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

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
        contentView.constraint(
            top: mainScrollView.contentLayoutGuide.topAnchor,
            bottom: mainScrollView.contentLayoutGuide.bottomAnchor,
            centerX: view.centerXAnchor,
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 160, right: 16))

        mainScrollView.addSubview(addPracticeSongButton)
        addPracticeSongButton.constraint(
            top: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))

        mainScrollView.addSubview(addCompleteButton)
        addCompleteButton.constraint(
            top: addPracticeSongButton.bottomAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 40, left: 16, bottom: 10, right: 16))
    }

    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCompleteButtonState),
            name: Notification.Name.checkUnRegisteredCardViewInformationFilled,
            object: nil
        )
    }

    private func applySnapshotForDeleteButton() {
        if contentView.arrangedSubviews.count == 1 {
            contentView.arrangedSubviews
                .compactMap { $0 as? UnRegisteredMemberCardView }
                .forEach { $0.deleteButton.isHidden = true }
        } else {
            contentView.arrangedSubviews
                .compactMap { $0 as? UnRegisteredMemberCardView }
                .forEach { $0.deleteButton.isHidden = false }
        }
    }
}
//MARK: - Extension

extension AddUnRegisteredMemberViewController {
    @objc func didTapAddPracticeSong() {
        let newCard = UnRegisteredMemberCardView()
        if contentView.arrangedSubviews.count == 3 { addPracticeSongButton.backgroundColor = .gray02 }
        guard contentView.arrangedSubviews.count < 3 else { return }
        contentView.insertArrangedSubview(
            newCard,
            at: contentView.arrangedSubviews.endIndex)
        applySnapshotForDeleteButton()

        // 필수 정보 누락 여부 체크 Notification Post
        NotificationCenter.default.post(name: Notification.Name.checkUnRegisteredCardViewInformationFilled, object: nil)
    }

    @objc
    private func updateCompleteButtonState() {
        let isAllRequiredInfoFilled = contentView.arrangedSubviews
            .compactMap { $0 as? UnRegisteredMemberCardView }
            .filter { $0.nickName().isEmpty || $0.isPositionSelected() == false }
            .isEmpty

        if isAllRequiredInfoFilled {
            addCompleteButton.isEnabled = true
        } else {
            addCompleteButton.isEnabled = false
        }
    }
}
