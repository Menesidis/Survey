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

    init(title: String = "-",
         name: String = "-",
         submittedQuestionsString: String = "-",
         previousButtonIsEnabled: Bool = false,
         nextButtonIsEnabled: Bool = true,
         interactor: QuestionsInteractorType) {
        
        self.interactor = interactor
        self.initialState = State(title: title,
                                  name: name,
                                  submittedQuestionsString: submittedQuestionsString,
                                  previousButtonIsEnabled: previousButtonIsEnabled,
                                  nextButtonIsEnabled: nextButtonIsEnabled,
                                  buttonType: .submitDisabled,
                                  notificationState: .none,
                                  answeredText: "",
                                  answerTextFieldIsEnabled: true)
    }
    
    enum Action {
        case load
        case next
        case previous
        case updateAnswer(answer: String)
        case submit
    }

    enum Mutation {
        case setTitle(title: String)
        case setName(name: String)
        case setPreviousButtonIsEnabled(enabled: Bool)
        case setNextButtonIsEnabled(enabled: Bool)
        case setSubmittedQuestionsString(submittedQuestionsString: String)
        case setButtonType(buttonType: ButtonType)
        case setNotificationState(notificationState: NotificationState)
        case setAnswerText(answerText: String)
        case setAnswerTextFieldIsEnabled(enabled: Bool)
    }
    
    func mutate(action: QuestionReactor.Action) -> Observable<QuestionReactor.Mutation> {
        switch action {
        case .load:
            return interactor
                .load()
                .flatMapLatest { questionDetails in
                    return Observable.concat([
                        Observable.just(Mutation.setTitle(title: questionDetails.title)),
                        Observable.just(Mutation.setName(name: questionDetails.name)),
                        Observable.just(Mutation.setSubmittedQuestionsString(submittedQuestionsString: questionDetails.submittedQuestionsString)),
                        Observable.just(Mutation.setPreviousButtonIsEnabled(enabled: questionDetails.previousEnabled)),
                        Observable.just(Mutation.setNextButtonIsEnabled(enabled: questionDetails.nextEnabled)),
                        Observable.just(Mutation.setAnswerText(answerText: questionDetails.answeredQuestion)),
                        Observable.just(Mutation.setButtonType(buttonType: questionDetails.buttonType)),
                        Observable.just(Mutation.setNotificationState(notificationState: questionDetails.notificationState)),
                        Observable.just(Mutation.setAnswerTextFieldIsEnabled(enabled: questionDetails.buttonType != .submitted))
                    ])
            }
        case .next:
            return interactor
                .next()
                .flatMapLatest { questionDetails in
                    return Observable.concat([
                        Observable.just(Mutation.setTitle(title: questionDetails.title)),
                        Observable.just(Mutation.setName(name: questionDetails.name)),
                        Observable.just(Mutation.setSubmittedQuestionsString(submittedQuestionsString: questionDetails.submittedQuestionsString)),
                        Observable.just(Mutation.setPreviousButtonIsEnabled(enabled: questionDetails.previousEnabled)),
                        Observable.just(Mutation.setNextButtonIsEnabled(enabled: questionDetails.nextEnabled)),
                        Observable.just(Mutation.setAnswerText(answerText: questionDetails.answeredQuestion)),
                        Observable.just(Mutation.setButtonType(buttonType: questionDetails.buttonType)),
                        Observable.just(Mutation.setNotificationState(notificationState: questionDetails.notificationState)),
                        Observable.just(Mutation.setAnswerTextFieldIsEnabled(enabled: questionDetails.buttonType != .submitted))
                    ])
            }
        case .previous:
            return interactor
                .previous()
                .flatMapLatest { questionDetails in
                    return Observable.concat([
                        Observable.just(Mutation.setTitle(title: questionDetails.title)),
                        Observable.just(Mutation.setName(name: questionDetails.name)),
                        Observable.just(Mutation.setSubmittedQuestionsString(submittedQuestionsString: questionDetails.submittedQuestionsString)),
                        Observable.just(Mutation.setPreviousButtonIsEnabled(enabled: questionDetails.previousEnabled)),
                        Observable.just(Mutation.setNextButtonIsEnabled(enabled: questionDetails.nextEnabled)),
                        Observable.just(Mutation.setAnswerText(answerText: questionDetails.answeredQuestion)),
                        Observable.just(Mutation.setButtonType(buttonType: questionDetails.buttonType)),
                        Observable.just(Mutation.setNotificationState(notificationState: questionDetails.notificationState)),
                        Observable.just(Mutation.setAnswerTextFieldIsEnabled(enabled: questionDetails.buttonType != .submitted))
                    ])
            }
        case .updateAnswer(answer: let answer):
            return interactor
                .updateAnswer(answer: answer)
                .flatMapLatest { questionDetails in
                    return Observable.concat([
                        Observable.just(Mutation.setNextButtonIsEnabled(enabled: questionDetails.nextEnabled)),
                        Observable.just(Mutation.setButtonType(buttonType: questionDetails.buttonType)),
                        Observable.just(Mutation.setAnswerText(answerText: questionDetails.answeredQuestion))
                    ])
            }
        case .submit:
            return interactor
                .submit()
                .flatMapLatest { questionDetails in
                    return Observable.concat([
                        Observable.just(Mutation.setSubmittedQuestionsString(submittedQuestionsString: questionDetails.submittedQuestionsString)),
                        Observable.just(Mutation.setButtonType(buttonType: questionDetails.buttonType)),
                        Observable.just(Mutation.setNotificationState(notificationState: questionDetails.notificationState)),
                        Observable.just(Mutation.setAnswerTextFieldIsEnabled(enabled: questionDetails.buttonType != .submitted))
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
        case .setSubmittedQuestionsString(submittedQuestionsString: let submittedQuestionsString):
            state.submittedQuestionsString = submittedQuestionsString
        case .setPreviousButtonIsEnabled(enabled: let enabled):
            state.previousButtonIsEnabled = enabled
        case .setNextButtonIsEnabled(enabled: let enabled):
            state.nextButtonIsEnabled = enabled
        case .setButtonType(buttonType: let buttonType):
            state.buttonType = buttonType
        case .setAnswerText(answerText: let text):
            state.answeredText = text
        case .setNotificationState(notificationState: let notificationState):
            state.notificationState = notificationState
        case .setAnswerTextFieldIsEnabled(enabled: let enabled):
            state.answerTextFieldIsEnabled = enabled
        }
        return state
    }
    
    struct State {
        var title: String
        var name: String
        var submittedQuestionsString: String
        var previousButtonIsEnabled: Bool
        var nextButtonIsEnabled: Bool
        var buttonType: ButtonType
        var notificationState: NotificationState
        var answeredText: String
        var answerTextFieldIsEnabled: Bool
    }
}
