//
//  AddPracticeSongViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/27.
//

import UIKit

final class AddPracticeSongViewController: UIViewController {

    let firstPracticeSongCard = PracticeSongCardView()

    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstPracticeSongCard])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
        return stackView
    }()

    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .dark01
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var addPracticeSongButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemPurple
        configuration.attributedTitle = AttributedString("합주곡 추가", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var completeAddButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemBlue
        configuration.attributedTitle = AttributedString("입력 완료", attributes: container)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapAddPracticeSong), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
    }

    override func viewDidLayoutSubviews() {
        applyButtonSnapshot()
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
        
        contentView.constraint(top: mainScrollView.contentLayoutGuide.topAnchor,
                               leading: mainScrollView.contentLayoutGuide.leadingAnchor,
                               bottom: mainScrollView.contentLayoutGuide.bottomAnchor,
                               trailing: mainScrollView.contentLayoutGuide.trailingAnchor,
                               padding: UIEdgeInsets(top: 20, left: 10, bottom: 160, right: 20))
        
        mainScrollView.addSubview(addPracticeSongButton)
        
        addPracticeSongButton.constraint(top: contentView.bottomAnchor,
                                         leading: contentView.leadingAnchor,
                                         trailing: contentView.trailingAnchor,
                                         padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        
        mainScrollView.addSubview(completeAddButton)

        completeAddButton.constraint(top: addPracticeSongButton.bottomAnchor,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                  padding: UIEdgeInsets(top: 40, left: 20, bottom: 10, right: 20))
    }

    private func applyButtonSnapshot() {
        // StackView에 들어간 하위뷰들은 UIView 타입으로 인식합니다. 그래서 그 안에 cancleButton 프로퍼티에 접근하기 위해 map을 사용합니다.
        if contentView.arrangedSubviews.count == 1 {
            contentView.arrangedSubviews.map { $0 as! PracticeSongCardView }.forEach { $0.deleteButton.isHidden = true }
        } else {
            contentView.arrangedSubviews.map { $0 as! PracticeSongCardView }.forEach { $0.deleteButton.isHidden = false }
        }
    }
}

// ScrollView 가로 스크롤 막기
extension AddPracticeSongViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if scrollView.contentOffset.x != 0 {
               scrollView.contentOffset.x = 0
           }
       }
}

extension AddPracticeSongViewController {
    @objc func didTapAddPracticeSong() {
        let newCard = PracticeSongCardView()
        guard contentView.arrangedSubviews.count < 3 else { return }
        contentView.insertArrangedSubview(newCard, at: contentView.arrangedSubviews.endIndex)
        applyButtonSnapshot()
    }
}
