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

enum ButtonType: Equatable {
    case submitEnabled
    case submitDisabled
    case submitted
    case submitting
}

extension ButtonType {
    
    var backgroundColor: UIColor {
        switch self {
        case .submitEnabled:
            return .white
        case .submitted:
            return .lightGray
        case .submitDisabled:
            return .lightGray
        case .submitting:
            return .lightGray
        }
    }

    var text: String {
        switch self {
        case .submitEnabled:
            return "Submit"
        case .submitted:
            return "Already submited!"
        case .submitDisabled:
            return "Submit"
        case .submitting:
            return "Submitting ... "
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .submitEnabled:
            return true
        case .submitted:
            return false
        case .submitDisabled:
            return false
        case .submitting:
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
