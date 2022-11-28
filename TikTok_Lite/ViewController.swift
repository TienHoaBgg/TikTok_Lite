//
//  ViewController.swift
//  TikTok_Lite
//
//  Created by NguyenTienHoa on 22/11/2022.
//

import UIKit
import WebKit
import SnapKit
import SwiftSoup
import Photos

class ViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    private lazy var assistantButton: CircleButton = {
        let button = CircleButton(frame: CGRect(x: 10, y: 150, width: 60, height: 60))
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        button.setBackgroundImage(UIImage(systemName: "circle.dashed.inset.fill"), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.5)
        button.addGestureRecognizer(panGesture)
        button.addTarget(self, action: #selector(assistantButtonSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gusture = UIPanGestureRecognizer(target: self, action: #selector(assistantButtonPanGesture(_:)))
        gusture.maximumNumberOfTouches = 1
        gusture.minimumNumberOfTouches = 1
        return gusture
    }()
    
    private lazy var cleanButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setTitle(" Clean popups", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "clear.fill"), for: .normal)
        button.addTarget(self, action: #selector(cleanButtonAction), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setTitle(" Download", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var transparentView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.transparentViewTapped(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var menuView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.frame.size = CGSize(width: 168, height: 90)
        view.radius = 8
        view.backgroundColor = .white
        view.addSubview(cleanButton)
        view.addSubview(downloadButton)
        cleanButton.snp.makeConstraints({
            $0.left.equalToSuperview().inset(8)
            $0.right.top.equalToSuperview();
            $0.height.equalTo(45)
        })
        downloadButton.snp.makeConstraints({
            $0.left.equalToSuperview().inset(8)
            $0.right.bottom.equalToSuperview();
            $0.height.equalTo(45)
        })
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(assistantButton)
        setupWebview()

    }

    private func setupWebview() {
        self.webView.navigationDelegate = self
        if let url = URL(string: "https://www.tiktok.com/foryou?is_from_webapp=v1&is_copy_url=1") {
            let urlRequest = URLRequest(url: url)
            ShowLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.webView.load(urlRequest)
            })
        }
    }
    
    @objc open func assistantButtonSelected() {
        self.view.addSubview(transparentView)
        self.transparentView.alpha = 0
        transparentView.frame = view.bounds
        transparentView.addSubview(menuView)
        
        var originX: CGFloat = assistantButton.frame.midX
        var originY: CGFloat = assistantButton.frame.midY
        if assistantButton.frame.midX > view.frame.midX {
            originX = assistantButton.frame.midX - menuView.frame.width
        }
        if assistantButton.frame.midY > view.frame.midY {
            originY = assistantButton.frame.midY - menuView.frame.height
        }
        
        let originMenu = CGPoint(x: originX, y: originY)
        menuView.frame.origin = originMenu
        UIView.animate(withDuration: 0.2) {
            self.transparentView.alpha = 1
        }
    }

    @objc func downloadButtonAction() {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            guard let html = html as? String else { return }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                if let element = try doc.getElementById("tiktok-webapp-mobile-player-container") {
                    if let videoLink = try element.select("video").first()?.attr("src") {
                        self.downloadVideo(videoLink)
                    }
                }
            } catch Exception.Error(_, let message) {
                ShowToast(icon: UIImage(systemName: "square.and.arrow.down.on.square.fill"),
                          str: message)
            } catch {
                ShowToast(icon: UIImage(systemName: "square.and.arrow.down.on.square.fill"),
                          str: "Download fail!")
            }
        })
        transparentViewTapped()
    }
    
    @objc func cleanButtonAction() {
        let view1 = "document.querySelector('.tiktok-hsy0fo-DivContainer').style.display='none';"
        let view2 = "document.querySelector('.tiktok-py8jux-DivModalContainer').style.display='none';"
        let view3 = "document.querySelector('.tiktok-a5lqug-DivFooterGuide').style.display='none';"
        webView.evaluateJavaScript(view1)
        webView.evaluateJavaScript(view2)
        webView.evaluateJavaScript(view3)
        transparentViewTapped()
    }
    
    @objc private func assistantButtonPanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        assistantButton.frame.origin = location
        if gesture.state == .ended {
            if location.x > view.center.x {
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    assistantButton.frame.origin.x = view.frame.maxX - assistantButton.frame.width - 12
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    assistantButton.frame.origin.x = 12
                })
            }
        }
    }
    
    @objc private func transparentViewTapped(_ gesture: UITapGestureRecognizer? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transparentView.alpha = 0
        }, completion: { _ in
            self.transparentView.removeFromSuperview()
        })
    }
    
    func downloadVideo(_ videoUrl: String) {
        ShowToast(icon: UIImage(systemName: "square.and.arrow.down.on.square.fill"),
                  str: "Downloading...")
        DispatchQueue.global(qos: .background).async {
          if let url = URL(string: videoUrl), let urlData = NSData(contentsOf: url) {
             let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
             let filePath="\(galleryPath)/\(randomString(length: 12)).mp4"
              DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                   PHPhotoLibrary.shared().performChanges({
                   PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:
                   URL(fileURLWithPath: filePath))
                }) {
                   success, error in
                   if success {
                       ShowToast(icon: UIImage(systemName: "square.and.arrow.down.on.square.fill"),
                                 str: "Download success!")
                   } else {
                       ShowToast(icon: UIImage(systemName: "square.and.arrow.down.on.square.fill"),
                                 str: error?.localizedDescription ?? "Download fail!")
                   }
                }
             }
          }
       }
    }
    
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let view1 = "document.querySelector('.tiktok-hsy0fo-DivContainer').style.display='none';"
        let view2 = "document.querySelector('.tiktok-a5lqug-DivFooterGuide').style.display='none';"
        webView.evaluateJavaScript(view1)
        webView.evaluateJavaScript(view2)
        StopLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error._code == -1009 { // internet not working
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                StopLoadingView()
            }
        }
        if error._code == -1001 { // time out
            StopLoadingView()
        }
        if error._code == -1003 { // domain not found
            StopLoadingView()
        }
    }
    
}
