//
//  QuestionInteractorTests.swift
//  SurveyTests
//
//  Created by Menesidis on 14/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Survey

class MockQuestionsRepository: QuestionsRepositoryType {
    func questions() -> Observable<[Question]> {
        return Observable.just(
            [
                Question(identifier: 1, name: "test1"),
                Question(identifier: 2, name: "test2"),
                Question(identifier: 3, name: "test3"),
                Question(identifier: 4, name: "test4"),
            ]
        )
    }
    
    func submit(request: AnswerRequest) -> Observable<Bool> {
        if request.page == 4 {
            return Observable.just(false)
        }
        return Observable.just(true)
    }
}


class QuestionInteractorTests: XCTestCase {
    
    func testButtonType() throws {
        let mockQuestionsRepository = MockQuestionsRepository()
        let interactor = QuestionsInteractor(questionsRepository: mockQuestionsRepository)
        let questionDetails = try interactor.load().toBlocking().first()!
        XCTAssertEqual(questionDetails.buttonType, .submitDisabled)
        
        let updatedQuestionDetails = try interactor.updateAnswer(answer: "hello").toBlocking().first()!
        XCTAssertEqual(updatedQuestionDetails.buttonType, .submitEnabled)
        
        let sucessfulQuestionDetails = try interactor.submit().toBlocking().first()!
        XCTAssertEqual(sucessfulQuestionDetails.buttonType, .submitted)
        
        let nextDetails = try interactor.next().toBlocking().first()!
        XCTAssertEqual(nextDetails.buttonType, .submitDisabled)
    }
    
    func testNotificationState() throws {
        let mockQuestionsRepository = MockQuestionsRepository()
        let interactor = QuestionsInteractor(questionsRepository: mockQuestionsRepository)
        let questionDetails = try interactor.load().toBlocking().first()!
        XCTAssertEqual(questionDetails.notificationState, .none)
        
        let sucessfulQuestionDetails = try interactor.submit().toBlocking().first()!
        XCTAssertEqual(sucessfulQuestionDetails.notificationState, .sucessful)
        
        let _ = try interactor.next().toBlocking().first()!
        let _ = try interactor.next().toBlocking().first()!
        let _ = try interactor.next().toBlocking().first()!
        let failedQuestionDetails = try interactor.submit().toBlocking().first()!
        
        XCTAssertEqual(failedQuestionDetails.notificationState, .failed)
    }
    
    func testPagerButtons() throws {
        let mockQuestionsRepository = MockQuestionsRepository()
        let interactor = QuestionsInteractor(questionsRepository: mockQuestionsRepository)
        
        let firstQuestionDetails = try interactor.load().toBlocking().first()!
        // Page 1
        XCTAssertEqual(firstQuestionDetails.nextEnabled, true)
        XCTAssertEqual(firstQuestionDetails.previousEnabled, false)
        // Page 2
        let secondsQuestionDetails = try interactor.next().toBlocking().first()!
        XCTAssertEqual(secondsQuestionDetails.nextEnabled, true)
        XCTAssertEqual(secondsQuestionDetails.previousEnabled, true)
        // Page 3
        let _ = try interactor.next().toBlocking().first()!
        // Page 4
        let lastQuestionDetails = try interactor.next().toBlocking().first()!
        XCTAssertEqual(lastQuestionDetails.nextEnabled, false)
        XCTAssertEqual(lastQuestionDetails.previousEnabled, true)
        // Page 3
        let thirdQuestionDetails = try interactor.previous().toBlocking().first()!
        XCTAssertEqual(thirdQuestionDetails.nextEnabled, true)
        XCTAssertEqual(thirdQuestionDetails.previousEnabled, true)
        // Page 2
        let _ = try interactor.previous().toBlocking().first()!
        // Page 1
        let firstDetails = try interactor.previous().toBlocking().first()!
        XCTAssertEqual(firstDetails.nextEnabled, true)
        XCTAssertEqual(firstDetails.previousEnabled, false)
        
    }
}
