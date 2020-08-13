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
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
      UIView.animate(withDuration: duration,
                     delay: delay,
                     options: UIView.AnimationOptions.curveEaseIn,
                     animations: {
        self.alpha = 0.0
      }, completion: completion)
    }
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
      UIView.animate(withDuration: duration,
                     delay: delay,
                     options: UIView.AnimationOptions.curveEaseOut,
                     animations: {
        self.alpha = 1.0
      }, completion: completion)
    }
}
