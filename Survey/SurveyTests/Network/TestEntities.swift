//
//  TestEntities.swift
//  SurveyTests
//
//  Created by Menesidis on 16/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
@testable import Survey

struct Test: BusinessModel, Equatable {
    let test: String
}

struct TestResponse: EntityResponse, Equatable {
    var businessModel: Test {
        return Test(test: test)
    }
    let test: String
}

struct TestErrorResponse: EntityErrorResponse, Equatable {

    let error_type: String
    let error_description: String

    var error: Error {
        return TestError.serverError("\(error_type): \(error_description)")
    }

    enum CodingKeys: String, CodingKey {
        case error_type = "error"
        case error_description
    }
}

enum TestError: Error {
    case serverError(String)
}
