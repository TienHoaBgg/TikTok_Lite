//
//  Utils.swift
//  TikTok_Lite
//
//  Created by NguyenTienHoa on 24/11/2022.
//

import UIKit
import Toast

func ShowLoadingView() {
    DispatchQueue.main.async {
        let scene = UIApplication.shared.connectedScenes.first
        guard let rootVC = (scene?.delegate as? SceneDelegate)?.window else { return }
        
        if rootVC.viewWithTag(10000) != nil {
            return
        }
        let view = LoadingView(frame: CGRect.zero)
        let screenSize = UIScreen.main.bounds.size
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        backView.addSubview((view))
        view.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(86)
            make.height.equalTo(86)
        }
        backView.backgroundColor = UIColor.clear
        backView.tag = 10000
        rootVC.addSubview(backView)
    }
}

func StopLoadingView() {
    DispatchQueue.main.async {
        let scene = UIApplication.shared.connectedScenes.first
        guard let rootVC = (scene?.delegate as? SceneDelegate)?.window else { return }
        rootVC.viewWithTag(10000)?.removeFromSuperview()
    }
}

func ShowToast(icon: UIImage?, str: String) {
    DispatchQueue.main.async {
        if let icon = icon {
            Toast.default(image: icon, title: str).show()
        } else {
            Toast.text(str).show()
        }
    }
}

func randomString(length: Int = 16) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in letters.randomElement()! })
}
