//
//  QuestionsEntities.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation

struct QuestionResponse: EntityResponse {
    typealias BM = Question

    let id: Int
    let question: String

    var businessModel: Question {
        return Question(identifier: id, name: question)
    }
}

struct QuestionErrorResponse: EntityErrorResponse {

    let error_type: String
    let error_description: String

    var error: Error {
        return QuestionError.serverError("\(error_type): \(error_description)")
    }

    enum CodingKeys: String, CodingKey {
        case error_type = "error"
        case error_description
    }

}

enum QuestionError: Error {
    case serverError(String)
}
