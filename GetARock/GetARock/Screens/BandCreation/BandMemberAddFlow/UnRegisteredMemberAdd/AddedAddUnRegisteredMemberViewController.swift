//
//  AddedAddUnRegisteredMemberViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

//TODO: API 업데이트 되면 TableCell에 선택한 여러 악기가 표기 되게 만들기 
final class AddUnRegisteredMemberViewController: BaseViewController {

    private var addedMembers: [MemberList2] = []

    var completion: (_ registeredMember: [MemberList2]) -> Void = { addedMembers in }

    private lazy var firstData: MemberList2 = MemberList2(memberId: 0, name: firstPracticeSongCard.bandMemberNameTextField.textField.text ?? "", memberState: "ANONYMOUS", instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: firstPracticeSongCard.otherPositionTextField.textField.text ?? "")], gender: "WOMEN", age: "TWENTIES")

    private lazy var firstPracticeSongCard: UnRegisteredMemberCardView = {
        let card = UnRegisteredMemberCardView()
        let action = UIAction { _ in
            self.addedMembers.append(self.firstData)
            self.addedMembers.removeAll { $0.id == self.firstData.id }
        }
        card.cancelButton.addAction(action, for: .touchUpInside)
        return card
    }()

    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 40
        return $0
    }(UIStackView(arrangedSubviews: [firstPracticeSongCard]))

    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UIScrollView())

    //TODO: 추후에 defualt 버튼으로 수정해야함

    private lazy var addPracticeSongButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        //TODO: 이전 PR 머지 이후 이미지 리터럴로 변경하기
        configuration.image = UIImage(systemName: "plus")
        configuration.title = "멤버 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        return button
    }()

    //TODO: 추후에 defualt 버튼으로 수정해야함
    private lazy var addCompletionButton: BottomButton = {
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("추가 완료", for: .normal)
        $0.addAction(addCompletionAction, for: .touchUpInside)
        return $0
    }(BottomButton())

    private lazy var addCompletionAction = UIAction { _ in
        for subview in self.contentView.arrangedSubviews {
            let card = subview as! UnRegisteredMemberCardView
            let data = MemberList2(memberId: 0, name: card.bandMemberNameTextField.textField.text ?? "", memberState: "ANONYMOUS", instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: card.otherPositionTextField.textField.text ?? "")], gender: "MEN", age: "TWENTIES")
            self.addedMembers.append(data)
        }
        self.dismiss(animated: true){
            self.completion(self.addedMembers)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        setKeyboardDismiss()
    }

    override func viewDidLayoutSubviews() {
        applySnapshotForDeleteButton()
    }

    private func attribute() {
        self.view.backgroundColor = .dark01
    }

    private func setupLayout() {

        view.addSubview(mainScrollView)
        mainScrollView.constraint(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

        mainScrollView.addSubview(contentView)
        contentView.constraint(top: mainScrollView.contentLayoutGuide.topAnchor, leading: mainScrollView.contentLayoutGuide.leadingAnchor, bottom: mainScrollView.contentLayoutGuide.bottomAnchor, trailing: mainScrollView.contentLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 10, bottom: 160, right: 20))

        mainScrollView.addSubview(addPracticeSongButton)
        addPracticeSongButton.constraint(top: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))

        mainScrollView.addSubview(addCompletionButton)
        addCompletionButton.constraint(top: addPracticeSongButton.bottomAnchor,leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20))
    }

    private func applySnapshotForDeleteButton() {
        if contentView.arrangedSubviews.count == 1 {
            contentView.arrangedSubviews.map { $0 as! UnRegisteredMemberCardView }.forEach { $0.cancelButton.isHidden = true }
        } else {
            contentView.arrangedSubviews.map { $0 as! UnRegisteredMemberCardView }.forEach { $0.cancelButton.isHidden = false }
        }
    }

    private func setKeyboardDismiss() {
           let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTouchScreen))
           recognizer.numberOfTapsRequired = 1
           recognizer.numberOfTouchesRequired = 1
           mainScrollView.addGestureRecognizer(recognizer)
       }
}

// ScrollView 가로 스크롤 막기
extension AddUnRegisteredMemberViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

extension AddUnRegisteredMemberViewController {
    @objc func didTapAddPracticeSong() {
        let newCard = UnRegisteredMemberCardView()
        guard contentView.arrangedSubviews.count < 3 else { return }
        // UI에 카드뷰 추가 (stackView에 넣는 방식임)
        contentView.insertArrangedSubview(
            newCard,
            at: contentView.arrangedSubviews.endIndex)
        applySnapshotForDeleteButton()
    }

    @objc func didTouchScreen() {
        self.view.endEditing(true)
    }
}


