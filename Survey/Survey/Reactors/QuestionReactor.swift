//
//  QuestionReactor.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

final class QuestionReactor: Reactor {
    
    let initialState: State
    private let interactor: QuestionsInteractorType
    
    deinit {
        print("♻️🚮 \(#file): \(#function)")
    }

    init(title: String = "Question -/-",
         name: String = "-",
         submittedQuestions: String = "-",
         previousButtonIsEnabled: Bool = false,
         nextButtonIsEnabled: Bool = true,
         interactor: QuestionsInteractorType) {
        
        self.interactor = interactor
        self.initialState = State(title: title,
                                  name: name,
                                  submittedQuestions: submittedQuestions,
                                  previousButtonIsEnabled: previousButtonIsEnabled,
                                  nextButtonIsEnabled: nextButtonIsEnabled,
                                  buttonType: .disabled(text: "Submit"))
    }
    
    enum Action {
        case load
    }

    enum Mutation {
        case setTitle(title: String)
        case setName(name: String)
        case setPreviousButtonIsEnabled(enabled: Bool)
        case setNextButtonIsEnabled(enabled: Bool)
        case setSubmittedQuestions(submittedQuestions: String)
        case setButtonType(buttonType: ButtonType)
    }
    
    func mutate(action: QuestionReactor.Action) -> Observable<QuestionReactor.Mutation> {
        switch action {
        case .load:
            return interactor.load().flatMapLatest { question in
                return Observable.concat([
                    Observable.just(Mutation.setTitle(title: question.title)),
                    Observable.just(Mutation.setName(name: question.name)),
                    Observable.just(Mutation.setSubmittedQuestions(submittedQuestions: question.submittedQuestions)),
                    Observable.just(Mutation.setPreviousButtonIsEnabled(enabled: question.previousEnabled)),
                    Observable.just(Mutation.setNextButtonIsEnabled(enabled: question.nextEnabled)),
                    Observable.just(Mutation.setButtonType(buttonType: question.buttonType))
                ])
            }
        }
    }
    
    func reduce(state: QuestionReactor.State, mutation: QuestionReactor.Mutation) -> QuestionReactor.State {
        var state = state
        
        switch mutation {
        case .setTitle(title: let title):
            state.title = title
        case .setName(name: let name):
            state.name = name
        case .setSubmittedQuestions(submittedQuestions: let submittedQuestions):
            state.submittedQuestions = submittedQuestions
        case .setPreviousButtonIsEnabled(enabled: let enabled):
            state.previousButtonIsEnabled = enabled
        case .setNextButtonIsEnabled(enabled: let enabled):
            state.nextButtonIsEnabled = enabled
        case .setButtonType(buttonType: let buttonType):
            state.buttonType = buttonType
        }
        return state
    }
    
    struct State {
        var title: String
        var name: String
        var submittedQuestions: String
        var previousButtonIsEnabled: Bool
        var nextButtonIsEnabled: Bool
        var buttonType: ButtonType
    }
}
