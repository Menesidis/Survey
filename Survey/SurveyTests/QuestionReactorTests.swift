//
//  QuestionReactorTests.swift
//  SurveyTests
//
//  Created by Menesidis on 14/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Survey

struct MockQuestionsInteractor: QuestionsInteractorType {
    func load(answer: String?, notificationState: NotificationState) -> Observable<QuestionDetails> {
        return Observable.just(QuestionDetails(title: "title",
                                               name: "name",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestionsString: "submitedQuestions",
                                               buttonType: .submitDisabled,
                                               answeredQuestion: "",
                                               notificationState: .none))
    }
    
    func next() -> Observable<QuestionDetails> {
        return Observable.just(QuestionDetails(title: "titleNext",
                                               name: "name",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestionsString: "submitedQuestions",
                                               buttonType: .submitDisabled,
                                               answeredQuestion: "",
                                               notificationState: .none))
    }
    
    func previous() -> Observable<QuestionDetails> {
                return Observable.just(QuestionDetails(title: "titlePrevious",
                                               name: "name",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestionsString: "submitedQuestions",
                                               buttonType: .submitDisabled,
                                               answeredQuestion: "",
                                               notificationState: .none))
    }
    
    func updateAnswer(answer: String) -> Observable<QuestionDetails> {
        return Observable.just(QuestionDetails(title: "title",
                                               name: "name",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestionsString: "submitedQuestions",
                                               buttonType: .submitDisabled,
                                               answeredQuestion: answer,
                                               notificationState: .none))
    }
    
    func submit() -> Observable<QuestionDetails> {
        return Observable.just(QuestionDetails(title: "title",
                                               name: "name",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestionsString: "submitedQuestions",
                                               buttonType: .submitEnabled,
                                               answeredQuestion: "",
                                               notificationState: .none))
    }
}

class QuestionReactorTests: XCTestCase {

    func testAnsweredText() {
        let mockQuestionsInteractor = MockQuestionsInteractor()
        let reactor = QuestionReactor(interactor: mockQuestionsInteractor)
        XCTAssertEqual(reactor.currentState.answeredText, "")
        reactor.action.onNext(.updateAnswer(answer: "Answered!"))
        XCTAssertEqual(reactor.currentState.answeredText, "Answered!")
    }
    
    func testSubmitAction() {
        let mockQuestionsInteractor = MockQuestionsInteractor()
        let reactor = QuestionReactor(interactor: mockQuestionsInteractor)
        XCTAssertEqual(reactor.currentState.buttonType, .submitDisabled)
        reactor.action.onNext(.submit)
        XCTAssertEqual(reactor.currentState.buttonType, .submitEnabled)
    }
    
    func testNextAction() {
        let mockQuestionsInteractor = MockQuestionsInteractor()
        let reactor = QuestionReactor(interactor: mockQuestionsInteractor)
        XCTAssertEqual(reactor.currentState.title, "-")
        reactor.action.onNext(.load)
        XCTAssertEqual(reactor.currentState.title, "title")
        reactor.action.onNext(.next)
        XCTAssertEqual(reactor.currentState.title, "titleNext")
    }
    
    func testPreviousAction() {
        let mockQuestionsInteractor = MockQuestionsInteractor()
        let reactor = QuestionReactor(interactor: mockQuestionsInteractor)
        XCTAssertEqual(reactor.currentState.title, "-")
        reactor.action.onNext(.load)
        XCTAssertEqual(reactor.currentState.title, "title")
        reactor.action.onNext(.previous)
        XCTAssertEqual(reactor.currentState.title, "titlePrevious")
    }
}
