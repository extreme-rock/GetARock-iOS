//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import SafariServices
import UIKit

class LandingViewController: UIViewController {

    let testData = [
        SnsListVO(snsID: 0, snsType: .youtube, link: "dake"),
        SnsListVO(snsID: 0, snsType: .instagram, link: "dake"),
        SnsListVO(snsID: 0, snsType: .soundcloud, link: "dake")
         ]
    lazy var test = SNSListStackView(data: testData)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(test)
        test.constraint(centerX: view.centerXAnchor)
        test.constraint(centerY: view.centerYAnchor)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentSNSViewController(_:)),
                                               name: Notification.Name.presentSNSSafariViewController,
                                               object: nil)
    }
    
    @objc
    private func presentSNSViewController(_ notification: Notification) {
        print(notification.userInfo)
        guard let snsURL = notification.userInfo?["snsURL"] as? String else { return }
        guard let url = URL(string: snsURL) else { return }
        let snsSafariViewController = SFSafariViewController(url: url)
        self.present(snsSafariViewController, animated: true)
    }
}
