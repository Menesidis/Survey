//
//  UIViewAdditions.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import UIKit

extension UIView {
    func rounded(cornerRadius: CGFloat? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        layer.masksToBounds = true
        
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        } else {
            // Default cornerRadius
            layer.cornerRadius = frame.height / 2
        }
        
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
        
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth
        }
    }
}
