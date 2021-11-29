//
//  WebViewController.swift
//  BaseCamping
//
//  Created by Sang hun Lee on 2021/11/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var mediaData: SocialMediaInfo?
    var baseURL: String = "https://www.google.com"
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mediaData!.title
        baseURL = mediaData!.link
        openWebPage(to: baseURL)
    }
    
    
    @IBAction func goBackBtnClicked(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func reloadBtnClicked(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goForwardBtnClicked(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        webView.stopLoading()
    }
    
    func openWebPage(to urlStr: String) {
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }
        let requset = URLRequest(url: url)
        webView.load(requset)
    }
}
