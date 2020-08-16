//
//  SurveyUITests.swift
//  SurveyUITests
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import XCTest

class SurveyUITests: XCTestCase {
    var app: XCUIApplication!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        // Since UI tests are more expensive to run, it's usually a good idea
        // to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }
    
    func testNextBarButtonsExists() {
        XCTAssertFalse(app.navigationBars.buttons["nextButton"].exists)
        app.buttons["surveyButton"].tap()
        XCTAssertTrue(app.navigationBars.buttons["nextButton"].exists)
    }
    
    func testPreviousButtonEnabled() {
        app.buttons["surveyButton"].tap()
        XCTAssertFalse(app.navigationBars.buttons["previousButton"].isEnabled)
        // TODO: Find a better way to wait async API call
        // Waiting to load questions from API
        sleep(4)
        
        app.navigationBars.buttons["nextButton"].tap()
        XCTAssertTrue(app.navigationBars.buttons["previousButton"].isEnabled)
        
        app.navigationBars.buttons["previousButton"].tap()
        XCTAssertFalse(app.navigationBars.buttons["previousButton"].isEnabled)
        
    }
    
    func testSubmitButtonEnabled() {
        app.buttons["surveyButton"].tap()
        XCTAssertFalse(app.buttons["submitButton"].isEnabled)
        
        let answerTextField = app.textFields["answerTextField"]
        answerTextField.tap()
        answerTextField.typeText("This is my answer!")
        XCTAssertTrue(app.buttons["submitButton"].isEnabled)
    }
    
    func testNavigationBannerExists() {
        app.buttons["surveyButton"].tap()
        
        let answerTextField = app.textFields["answerTextField"]
        answerTextField.tap()
        answerTextField.typeText("This is my answer!")
        
        app.buttons["submitButton"].tap()
        
        // Waiting
        let notificationView = XCUIApplication().otherElements["notificationView"]
        XCTAssertFalse(notificationView.exists)
        XCTAssertTrue(notificationView.waitForExistence(timeout: 2.5))
    }
    
    func testKeyboardIsHidden() {
        app.buttons["surveyButton"].tap()
        
        // Keyboard is NOT visible
        XCTAssertFalse(app.keyboards.count > 0)
        
        let answerTextField = app.textFields["answerTextField"]
        answerTextField.tap()
        answerTextField.typeText("I will tap Return!!!")
        
        // Keyboard is visible
        XCTAssertTrue(app.keyboards.count > 0)
        XCUIApplication().keyboards.buttons["return"].tap()

        // Keyboard is NOT visible
        XCTAssertFalse(app.keyboards.count > 0)
    }
}
