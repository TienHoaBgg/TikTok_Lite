//
//  CircleButton.swift
//  TikTok_Lite
//
//  Created by NguyenTienHoa on 23/11/2022.
//

import UIKit

class CircleButton: UIButton {
    
    public override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.clipsToBounds = true
        super.layoutSubviews()
    }
    
    public func makeBackgroudClick() {
        self.layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.white.withAlphaComponent(0)
            self.layer.borderWidth = 0
        })
    }
    
}
