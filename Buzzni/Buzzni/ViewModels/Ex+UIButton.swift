//
//  Ex+UIButton.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/14.
//

import UIKit

@IBDesignable
class Ex_UIButton: UIButton {

    @IBInspectable var connerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = connerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
