//
//  SnsWebViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/01.
//

import UIKit
import WebKit

class SnsWebViewController: UIViewController {
    
    // MARK: - Property
    
    private let url : URL
    
    private let configuration: WKWebViewConfiguration = {
        $0.defaultWebpagePreferences.allowsContentJavaScript = true
        return $0
    }(WKWebViewConfiguration())
    
    private lazy var webview: WKWebView = {
        return $0
    }(WKWebView(frame: .zero, configuration: configuration))
    
    // MARK: - Init
    init(url: URL, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.frame = view.bounds
    }
}
