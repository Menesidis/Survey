//
//  QuestionViewControllerTests.swift
//  SurveyTests
//
//  Created by Menesidis on 14/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import XCTest
@testable import Survey

class QuestionViewControllerTests: XCTestCase {

    var reactor: QuestionReactor!
    var viewController: QuestionViewController!
    
    override func setUp() {
        let interactor = MockQuestionsInteractor()
        reactor = QuestionReactor(interactor: interactor)
        reactor.isStubEnabled = true
        
        viewController = QuestionViewController(reactor: reactor)
        viewController.loadView()
        viewController.viewDidLoad()
    }
    
    func testInitWithCoder() {
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
        let viewController = QuestionViewController(coder: coder)
        XCTAssertNil(viewController)
    }

    func testNotificationStates() {
        // Initial state
        reactor.stub.state.value = QuestionReactor.State(title: "title1",
                                                         name: "name1",
                                                         submittedQuestionsString: "submitQuestion",
                                                         previousButtonIsEnabled: true,
                                                         nextButtonIsEnabled: true,
                                                         buttonType: .submitEnabled,
                                                         notificationState: .none,
                                                         answeredText: "",
                                                         answerTextFieldIsEnabled: true)
        XCTAssertEqual(viewController.notificationView.isHidden, true)
        
        // Sucessful state
        reactor.stub.state.value = QuestionReactor.State(title: "title1",
                                                         name: "name1",
                                                         submittedQuestionsString: "submitQuestion",
                                                         previousButtonIsEnabled: false,
                                                         nextButtonIsEnabled: true,
                                                         buttonType: .submitEnabled,
                                                         notificationState: .sucessful,
                                                         answeredText: "",
                                                         answerTextFieldIsEnabled: true)
        XCTAssertEqual(self.viewController.notificationView.isHidden, false)
        
        // Failed state
        self.reactor.stub.state.value = QuestionReactor.State(title: "title1",
                                                              name: "name1",
                                                              submittedQuestionsString: "submitQuestion",
                                                              previousButtonIsEnabled: false,
                                                              nextButtonIsEnabled: true,
                                                              buttonType: .submitEnabled,
                                                              notificationState: .failed,
                                                              answeredText: "",
                                                              answerTextFieldIsEnabled: true)
        XCTAssertEqual(self.viewController.notificationView.isHidden, false)
    }
}
