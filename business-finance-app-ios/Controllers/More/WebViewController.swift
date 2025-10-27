//
//  WebViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 10/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(with url: URL) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    private(set) var url: URL?
    
    let webView: WKWebView = {
        let configuration     = WKWebViewConfiguration()
        let webview           = WKWebView(frame: .zero, configuration: configuration)
        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.allowsBackForwardNavigationGestures = false
        webview.backgroundColor = .white
        return webview
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.App.Button.backgroundColor
        indicator.tintColor = UIColor.App.Button.backgroundColor
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubView(webView, insets: .zero)
        webView.navigationDelegate = self
        view.backgroundColor = .white

        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 24),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor)
        ])
        webView.alpha = 0.6
        
        if let url = self.url {
            let request = URLRequest(url: url)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadingIndicator.startAnimating()
            webView.load(request)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.alpha = 0.6
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 1.0
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.alpha = 1.0
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        loadingIndicator.stopAnimating()
    }
}
