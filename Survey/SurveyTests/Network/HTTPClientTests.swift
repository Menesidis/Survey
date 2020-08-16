//
//  HTTPClientTests.swift
//  SurveyTests
//
//  Created by Menesidis on 15/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import XCTest
import RxSwift
import Moya
import RxBlocking
@testable import Survey

class HTTPClientTests: XCTestCase {

     // Test that HTTPClient produces the expected TestResponse
    func testSuccessfullRequestSingle() throws {
        let provider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)
        let testResponse = try httpClient.requestSingle(target: TestTarget.test(hasError: false), responseType: TestResponse.self, errorType: TestErrorResponse.self).toBlocking().first()!
        XCTAssertEqual(testResponse, TestResponse(test: "testValue"))
    }

    // Test that HTTPClient produces the expected serverError
    func testFailedRequestSingle() throws {
        let provider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)

        do {
            try _ = httpClient.requestSingle(target: TestTarget.test(hasError: true), responseType: TestResponse.self, errorType: TestErrorResponse.self).toBlocking().first()!
        } catch {
            if case TestError.serverError(let errorValue) = error {
                XCTAssertEqual(errorValue, "unauthorized: Authorization_needed!")
            } else {
                 XCTFail()
            }
        }
    }

    // Test that HTTPClient produces the expected TestResponse
    func testSuccessfullRequestCollection() throws {
        let provider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)
        let testResponse = try httpClient.requestCollection(target: TestTarget.tests(hasError: false), responseType: [TestResponse].self, errorType: TestErrorResponse.self).toBlocking().first()
        XCTAssertEqual(testResponse, [TestResponse(test: "testValue")])
    }

    // Test that HTTPClient produces the expected serverError
    func testFailedRequestCollection() throws {
        let provider = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)

        do {
            try _ = httpClient.requestCollection(target: TestTarget.tests(hasError: true), responseType: [TestResponse].self, errorType: TestErrorResponse.self).toBlocking().first()
        } catch {
            if case TestError.serverError(let errorValue) = error {
                XCTAssertEqual(errorValue, "unauthorized: Authorization_needed!")
            } else {
                XCTFail()
            }
        }
    }
    
    // Test that HTTPClient produces the expected parsing error
    func testRequestSingleWithParsingError() throws {

        let testObject: [String: String] = ["wrongTestKey": "test!"]
        let data = try JSONSerialization.data(withJSONObject: testObject, options: .prettyPrinted)

        let endPointClosure = { (target: MultiTarget) -> Endpoint in
            let url = URL(target: target).absoluteString
            let endPoint = Endpoint(url: url,
                                    sampleResponseClosure: {.networkResponse(200, data)},
                                    method: target.method,
                                    task: target.task,
                                    httpHeaderFields: target.headers)
            return endPoint
        }

        let provider = MoyaProvider<MultiTarget>(endpointClosure: endPointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)

        do {
            try _ = httpClient.requestSingle(target: TestTarget.test(hasError: false), responseType: TestResponse.self, errorType: TestErrorResponse.self).toBlocking().first()!
        } catch {
            if case HTTPClient.HTTPClientError.parsingError(_, _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }

    func testRequestCollectionWithParsingError() throws {

        let testObject: [String: String] = ["wrongTestKey": "test!"]
        let data = try JSONSerialization.data(withJSONObject: testObject, options: .prettyPrinted)

        let endPointClosure = { (target: MultiTarget) -> Endpoint in
            let url = URL(target: target).absoluteString
            let endPoint = Endpoint(url: url,
                                    sampleResponseClosure: {.networkResponse(200, data)},
                                    method: target.method,
                                    task: target.task,
                                    httpHeaderFields: target.headers)
            return endPoint
        }

        let provider = MoyaProvider<MultiTarget>(endpointClosure: endPointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let httpClient = HTTPClient(provider: provider)

        do {
            try _ = httpClient.requestCollection(target: TestTarget.test(hasError: false), responseType: [TestResponse].self, errorType: TestErrorResponse.self).toBlocking().first()
        } catch {
            if case HTTPClient.HTTPClientError.parsingError(_, _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }
}
