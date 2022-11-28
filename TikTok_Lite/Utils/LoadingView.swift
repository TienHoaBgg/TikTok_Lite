//
//  LoadingView.swift
//  TikTok_Lite
//
//  Created by NguyenTienHoa on 24/11/2022.
//

import UIKit

class LoadingView: UIView {
    
    private lazy var spinnerView: SpinnerView = {
        let view = SpinnerView(frame: CGRect.zero)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.addSubview(spinnerView)
        spinnerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview().inset(16)
        }
    }
    
}
