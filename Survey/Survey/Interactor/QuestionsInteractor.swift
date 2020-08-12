//
//  QuestionsInteractor.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import RxSwift

protocol QuestionsInteractorType: InteractorType {
    func load() -> Observable<QuestionDetails>
}

class QuestionsInteractor: QuestionsInteractorType {
    func load() -> Observable<QuestionDetails> {
        return Observable.just(QuestionDetails(title: "Question 1/20",
                                               name: "What's your favourite color?",
                                               previousEnabled: false,
                                               nextEnabled: true,
                                               submittedQuestions: "Questions submitted: 0",
                                               buttonType: .disabled(text: "Submit")))
    }
}
