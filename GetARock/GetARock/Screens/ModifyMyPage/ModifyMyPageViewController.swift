//
//  ModifyMyPageViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/13.
//

import UIKit

final class ModifyMyPageViewController: UIViewController {
    
    //MARK: - Property
    
    private let pageViewControllers: [UIViewController] = [
        ModifyPositionViewController(positions: [
            .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
            .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
            .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
            .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
            .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false)),
            .plusPosition
        ]),
        ModifyUserProfileViewController()]
    
    private var currentPageNumber: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPageNumber ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [pageViewControllers[self.currentPageNumber]],
                direction: direction,
                animated: false
            )
        }
    }
    
    //MARK: - View
    
    private lazy var dismissButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        let action = UIAction { [weak self] _ in
            self?.dismissButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
       return $0
    }(UIButton())
    
    private lazy var completeButton: UIButton = {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = .setFont(.headline04)
        let action = UIAction { [weak self] _ in
            self?.completeButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
       return $0
    }(UIButton())
    
    private let viewControllerTitleLabel = BasicLabel(
        contentText: "프로필 수정",
        fontStyle: .headline02,
        textColorInfo: .white
    )
    private lazy var segmentedController: ModifyPageSegmentedControl = {
        $0.addTarget(self,
                     action: #selector(segmentedControlValueChanged(_:)),
                     for: .valueChanged)
        return $0
    }(ModifyPageSegmentedControl(items: ["포지션", "내 정보"]))
    
    private lazy var pageViewController: UIPageViewController = {
        if let viewController = pageViewControllers.first {
            $0.setViewControllers([viewController],
                                  direction: .forward,
                                  animated: true)
        }
        return $0
    }(UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal))
    
    //MARK: - Life Cycle
    
    // init 시에 유저에 대한 정보가 들어와야함
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
    }
    
    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func completeButtonTapped() {
        //TODO: 개인정보 UPDATE 함수
    }
    
    private func setupLayout() {
        self.view.addSubview(dismissButton)
        dismissButton.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                 padding: UIEdgeInsets(top: 19, left: 19, bottom: 0, right: 0))
        dismissButton.constraint(
            .heightAnchor,
            constant: dismissButton.imageView?.intrinsicContentSize.height ?? 15.5)
        
        self.view.addSubview(viewControllerTitleLabel)
        viewControllerTitleLabel.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                            centerX: view.centerXAnchor,
                                            padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        
        self.view.addSubview(completeButton)
        completeButton.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 19))
        completeButton.constraint(
            .heightAnchor,
            constant: completeButton.titleLabel?.intrinsicContentSize.height ?? 0
        )

        self.view.addSubview(segmentedController)
        segmentedController.constraint(top: viewControllerTitleLabel.bottomAnchor,
                                       leading: view.leadingAnchor,
                                       trailing: view.trailingAnchor,
                                       padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16))
        segmentedController.constraint(.heightAnchor, constant: 50)

        self.view.addSubview(pageViewController.view)
        pageViewController.view.constraint(top: segmentedController.bottomAnchor,
                                           leading: view.leadingAnchor,
                                           bottom: view.bottomAnchor,
                                           trailing: view.trailingAnchor,
                                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: ModifyPageSegmentedControl) {
        currentPageNumber = self.segmentedController.selectedSegmentIndex
    }
}
