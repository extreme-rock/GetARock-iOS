//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandDetailViewController: UIViewController {
    
    // MARK: - Property
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - View
    private let bandTopInfoView = DetailTopInfoView(type:.band)
    
    private let bandSegmentedControl: InformationPageSegmentedControl = {
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
        return $0
    }(InformationPageSegmentedControl(items: ["밴드정보", "타임라인", "방명록"]))
    
    //임시 View들입니다..! 추후 삭제예쩡
    private let vc1: UIViewController = {
        $0.view.backgroundColor = .red
        return $0
    }(UIViewController())
    
    private let vc2: UIViewController = {
        $0.view.backgroundColor = .green
        return $0
    }(UIViewController())
    
    private let vc3: UIViewController = {
        $0.view.backgroundColor = .blue
        return $0
    }(UIViewController())
    
    var dataViewControllers: [UIViewController] {
        [self.vc1, self.vc2, self.vc3]
    }
    
    private lazy var pageViewController: UIPageViewController = {
        $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
    }
    
    // MARK: - Mothd
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.view.addSubview(self.bandTopInfoView)
        self.bandTopInfoView.constraint(top: self.view.topAnchor,
                                        leading: self.view.leadingAnchor,
                                        trailing: self.view.trailingAnchor,
                                        padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        
        self.view.addSubview(self.bandSegmentedControl)
        self.bandSegmentedControl.constraint(top: bandTopInfoView.bottomAnchor,
                                             leading: self.view.leadingAnchor,
                                             trailing: self.view.trailingAnchor,
                                             padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        bandSegmentedControl.constraint(.heightAnchor, constant: 60)
        
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.view.constraint(top:bandSegmentedControl.bottomAnchor,
                                                leading: self.view.leadingAnchor,
                                                bottom: self.view.bottomAnchor,
                                                trailing: self.view.trailingAnchor,
                                                padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - extension BandDetailViewController

extension BandDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.dataViewControllers.firstIndex(of: viewController),
              index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.bandSegmentedControl.selectedSegmentIndex = index
    }
}
