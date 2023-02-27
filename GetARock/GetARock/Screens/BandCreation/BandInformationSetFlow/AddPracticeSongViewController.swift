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
    
    private lazy var addPracticeSongButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.setFont(.contentBold)
        configuration.baseBackgroundColor = .systemPurple
        configuration.attributedTitle = AttributedString("합주곡 추가", attributes: container)
        configuration.image = ImageLiteral.plusSymbol
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
        //TODO: 강제언래핑 없애기
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
