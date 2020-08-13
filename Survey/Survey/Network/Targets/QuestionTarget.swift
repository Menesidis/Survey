//
//  QuestionTarget.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Moya

enum QuestionTarget {
    case questions
    case submit(request: AnswerRequest)
}

extension QuestionTarget: TargetType {

    var baseURL: URL {
        return URL(string: "https://powerful-peak-54206.herokuapp.com/")!
    }

    var path: String {
        switch self {
        case .questions:
            return "questions"
        case .submit:
            return "question/submit"
        }
    }

    var method: Moya.Method {
        switch self {
        case .questions:
            return .get
        case .submit:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .questions:
            return .requestPlain
        case .submit(request: let request):
            return .requestParameters(parameters: request.parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        let defaultHeaders = [
            "Content-type": "application/json"
        ]

        return defaultHeaders
    }

    var sampleData: Data {
        return Data()
    }
}
