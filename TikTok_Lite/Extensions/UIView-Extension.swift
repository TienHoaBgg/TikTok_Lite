//
//  UIView-Extension.swift
//  TikTok_Lite
//
//  Created by NguyenTienHoa on 23/11/2022.
//

import Foundation
import UIKit


extension UIView {
    
    @IBInspectable var radius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(value){
            self.layer.cornerRadius = value
            self.layer.masksToBounds = value > 0
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get{
            return self.layer.borderWidth
        }
        set(value){
            self.layer.borderWidth = value
        }
    }
    
}
