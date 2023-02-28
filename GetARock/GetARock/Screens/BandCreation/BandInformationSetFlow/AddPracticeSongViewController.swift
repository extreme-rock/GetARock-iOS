//
//  AddPracticeSongViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/27.
//

import UIKit

final class AddPracticeSongViewController: BaseViewController {
    
    var completion: (_ songs: [PracticeSongCardView]) -> Void = { songs in }
    
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
    
    private lazy var addPracticeSongButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "합주곡 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 10
        let button = DefaultButton(configuration: configuration)
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
    @objc
    func didTapAddPracticeSong() {
        let newCard = PracticeSongCardView()
        guard contentView.arrangedSubviews.count < 3 else { return }
        contentView.insertArrangedSubview(newCard, at: contentView.arrangedSubviews.endIndex)
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
}
