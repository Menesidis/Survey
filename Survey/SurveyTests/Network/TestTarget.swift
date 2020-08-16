//
//  TestTarget.swift
//  SurveyTests
//
//  Created by Menesidis on 16/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Moya

enum TestTarget {
    case test(hasError: Bool)
    case tests(hasError: Bool)
}

extension TestTarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.test.gr")!
    }

    var path: String {
        switch self {
        case .test, .tests:
            return "test/test1"
        }
    }

    var method: Moya.Method {
        switch self {
        case .test, .tests:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .test(let hasError):
            if hasError {
                return "{\"error\": \"unauthorized\", \"error_description\": \"Authorization_needed!\"}".utf8Encoded
            } else {
                return "{\"test\": \"testValue\"}".utf8Encoded
            }
        case .tests(hasError: let hasError):
            if hasError {
                return "{\"error\": \"unauthorized\", \"error_description\": \"Authorization_needed!\"}".utf8Encoded
            } else {
                return "[{\"test\": \"testValue\"}]".utf8Encoded
            }
        }
    }

    var task: Task {
        switch self {
        case .test, .tests:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

// MARK: - Helpers
private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
