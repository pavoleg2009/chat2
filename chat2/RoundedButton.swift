//
//  RoundedButton.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 08/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
  
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
            
        }
    }
}
