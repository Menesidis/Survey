//
//  QuestionDetails.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation

struct QuestionDetails: Presentable {
    let title: String
    let name: String
    let previousEnabled: Bool
    let nextEnabled: Bool
    let submittedQuestions: String
    let buttonType: ButtonType
    let answeredQuestion: String
    let notificationState: NotificationState
}
