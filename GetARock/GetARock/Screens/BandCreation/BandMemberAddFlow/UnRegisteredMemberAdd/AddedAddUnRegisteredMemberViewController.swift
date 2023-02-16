//
//  AddedAddUnRegisteredMemberViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit

final class AddUnRegisteredMemberViewController: UIViewController {

    private var addedMembers: [MemberList2] = []

    var completion: (_ registeredMember: [MemberList2]) -> Void = { addedMembers in }

    private lazy var firstData: MemberList2 = MemberList2(memberId: 0, name: firstPracticeSongCard.bandMemberNameTextField.textField.text ?? "", memberState: "NONE", instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: firstPracticeSongCard.otherPositionTextField.textField.text ?? "")])

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
    private lazy var addPracticeSongButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemPurple
        configuration.attributedTitle = AttributedString("멤버 추가", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)

        return button
    }()

    //TODO: 추후에 defualt 버튼으로 수정해야함
    private lazy var addCompletionButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemBlue
        configuration.attributedTitle = AttributedString("추가 완료", attributes: container)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        let button = UIButton(configuration: configuration, primaryAction: addCompletionAction)
        return button
    }()

    private lazy var addCompletionAction = UIAction { _ in
        for subview in self.contentView.arrangedSubviews {
            let card = subview as! UnRegisteredMemberCardView
            let data = MemberList2(memberId: 0, name: card.bandMemberNameTextField.textField.text ?? "", memberState: "NONE", instrumentList: [InstrumentList2(instrumentId: 0, isMain: true, name: card.otherPositionTextField.textField.text ?? "")])
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
        addPracticeSongButton.constraint(top: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))

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
}


