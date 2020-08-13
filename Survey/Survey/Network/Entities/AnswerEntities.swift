//
//  AnswerEntities.swift
//  Survey
//
//  Created by Menesidis on 13/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation

struct AnswerRequest: EntityRequest {
    let page: Int
    let answer: String
    
    var parameters: [String: Any] {
        return [
            "id": page,
            "answer": answer
        ]
    }
}

extension Bool: BusinessModel {}

struct AnswerResponse: EntityResponse {
    typealias BM = Bool
    
    let isSuccessful: Bool
    
    var businessModel: Bool {
        return isSuccessful
    }
}

struct AnswerErrorResponse: EntityErrorResponse {
    
    let error_type: String
    let error_description: String
    var error: Error {
        return AnswerError.serverError("\(error_type): \(error_description)")
    }
    
    enum CodingKeys: String, CodingKey {
        case error_type = "error"
        case error_description
    }
}

enum AnswerError: Error {
    case serverError(String)
}
