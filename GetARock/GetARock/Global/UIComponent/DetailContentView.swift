//
//  DetailContentView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class DetailContentView: UIView {
    
    // MARK: - Property
    
    enum DetailTopInfoType {
        case band
        case event
        case myPage
    }
    
    private lazy var segmentTitle: [String] = {
        switch detailTopInfoType {
        case .band:
            return ["밴드상세", "타임라인", "방명록"]
        case .event:
            return ["모여락상세", "댓글"]
        case .myPage:
            return ["프로필", "타임라인", "방명록"]
        }
    }()
    
    private var detailTopInfoType : DetailTopInfoType
    
    private var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [detailContentViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    private var bandData: BandInformationVO
    
    // MARK: - View
    
    var detailContentViewControllers: [UIViewController] = []
    
    private lazy var segmentedControl: InformationPageSegmentedControl = {
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
        return $0
    }(InformationPageSegmentedControl(items: segmentTitle))
    
    private lazy var pageViewController: UIPageViewController = {
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPageViewController(transitionStyle: .scroll,
                           navigationOrientation: .horizontal,
                           options: nil))
    
    // MARK: - Init
    
    init(type: DetailTopInfoType, bandData: BandInformationVO ) {
        self.detailTopInfoType = type
        self.bandData = bandData
        super.init(frame: .zero)
        setupLayout()
        attribute()
        setDetailViewController()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.addSubview(self.segmentedControl)
        self.segmentedControl.constraint(.heightAnchor, constant: 60)
        self.segmentedControl.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        self.addSubview(self.pageViewController.view)
        self.pageViewController.view.constraint(
            top:segmentedControl.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        )
    }
    
    private func setDetailViewController() {
        switch detailTopInfoType {
        case .band:
            
            // TODO: 임시 View들입니다. 추후 변경 예정
            let vc1: UIViewController = {
                $0.view.backgroundColor = .red
                return $0
            }(UIViewController())
            
            let vc2: UIViewController = {
                $0.view.backgroundColor = .orange
                return $0
            }(UIViewController())
            
            let vc3: UIViewController = {
                let bandCommentList = CommentListView(data: bandData.commentList)
                $0.view.addSubview(bandCommentList)
                bandCommentList.constraint(
                    top: $0.view.topAnchor,
                    leading: $0.view.leadingAnchor,
                    bottom: $0.view.bottomAnchor,
                    trailing: $0.view.trailingAnchor
                )
                return $0
            }(UIViewController())
            
            detailContentViewControllers = [vc1, vc2, vc3]
            
        case .event:
            
            // TODO: 임시 View들입니다. 추후 변경 예정
            let vc1: UIViewController = {
                $0.view.backgroundColor = .green
                return $0
            }(UIViewController())
            
            let vc2: UIViewController = {
                $0.view.backgroundColor = .blue
                return $0
            }(UIViewController())
            
            detailContentViewControllers = [vc1, vc2]
            
        case .myPage:
            
            // TODO: 임시 View들입니다. 추후 변경 예정
            let vc1: UIViewController = {
                $0.view.backgroundColor = .purple
                return $0
            }(UIViewController())
            
            let vc2: UIViewController = {
                $0.view.backgroundColor = .systemPink
                return $0
            }(UIViewController())
            
            let vc3: UIViewController = {
                $0.view.backgroundColor = .black
                return $0
            }(UIViewController())
            
            detailContentViewControllers = [vc1, vc2, vc3]
        }
        pageViewController.setViewControllers(
            [self.detailContentViewControllers[0]], direction: .forward, animated: true
        )
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension DetailContentView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore
                            viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.detailContentViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return self.detailContentViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter
                            viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.detailContentViewControllers.firstIndex(of: viewController),
              index + 1 < self.detailContentViewControllers.count
        else { return nil }
        return self.detailContentViewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension DetailContentView: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
              let index = self.detailContentViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

