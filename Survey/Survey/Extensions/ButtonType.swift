//
//  ButtonType.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ButtonType {
    case submit(text: String)
    case submitted(text: String)
    case disabled(text: String)
}

extension ButtonType {
    
    var backgroundColor: UIColor {
        switch self {
        case .submit:
            return .white
        case .submitted:
            return .lightGray
        case .disabled:
            return .lightGray
        }
    }

    var text: String {
        switch self {
        case .submit(text: let text):
            return text
        case .submitted(text: let text):
            return text
        case .disabled(text: let text):
            return text
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .submit:
            return true
        case .submitted:
            return false
        case .disabled:
            return false
        }
    }
}

extension Reactive where Base: UIButton {
    var buttonType: Binder<ButtonType> {
        return Binder(base) { button, buttonType in
            button.setTitle(buttonType.text, for: .normal)
            button.isEnabled = buttonType.isEnabled
            button.backgroundColor = buttonType.backgroundColor
        }
    }
}
