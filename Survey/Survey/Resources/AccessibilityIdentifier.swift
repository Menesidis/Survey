//
//  AccessibilityIdentifier.swift
//  Survey
//
//  Created by Menesidis on 16/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation

public enum AccessibilityIdentifier {

    enum Landing: String {
        case surveyButton
    }

    enum Question: String {
        case previousButton
        case nextButton
        case submitButton
        case answerTextField
        case notificationView
    }
}
