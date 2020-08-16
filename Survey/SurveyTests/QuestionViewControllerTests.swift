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
                                                         answeredText: "",
                                                         notificationState: .none)
        XCTAssertEqual(viewController.notificationView.isHidden, true)
        // Sucessful state
        reactor.stub.state.value = QuestionReactor.State(title: "title1",
                                                              name: "name1",
                                                              submittedQuestionsString: "submitQuestion",
                                                              previousButtonIsEnabled: false,
                                                              nextButtonIsEnabled: true,
                                                              buttonType: .submitEnabled,
                                                              answeredText: "",
                                                              notificationState: .sucessful)

        let expectation1 = expectation(description: "Sucessful state after 3.0 seconds")
        let result1 = XCTWaiter.wait(for: [expectation1], timeout: 3.0)
        if result1 == XCTWaiter.Result.timedOut {
            XCTAssertEqual(self.viewController.notificationView.isHidden, false)
        } else {
            XCTFail("Timed out!")
        }
        // Failed state
        self.reactor.stub.state.value = QuestionReactor.State(title: "title1",
                                                              name: "name1",
                                                              submittedQuestionsString: "submitQuestion",
                                                              previousButtonIsEnabled: false,
                                                              nextButtonIsEnabled: true,
                                                              buttonType: .submitEnabled,
                                                              answeredText: "",
                                                              notificationState: .failed)
        let expectation2 = expectation(description: "Failed state after 3 seconds")
        let result2 = XCTWaiter.wait(for: [expectation2], timeout: 3.0)
        if result2 == XCTWaiter.Result.timedOut {
            XCTAssertEqual(self.viewController.notificationView.isHidden, false)
        } else {
            XCTFail("Timed out!")
        }
    }
}
