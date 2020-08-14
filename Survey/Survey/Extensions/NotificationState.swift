//
//  NotificationState.swift
//  Survey
//
//  Created by Menesidis on 13/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NotificationState {
    case sucessful
    case failed
    case none
}


extension NotificationState {
    var backgroundColor: UIColor {
        switch self {
        case .sucessful:
            return .green
        case .failed:
            return .red
        case .none:
            return .clear
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .failed, .sucessful:
            return false
        case .none:
            return true
        }
    }
}
extension Reactive where Base: UIView {
    var notificationState: Binder<NotificationState> {
        return Binder(base) { view, notificationState in
            view.backgroundColor = notificationState.backgroundColor
            view.isHidden = notificationState.isHidden
        }
    }
}
