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
    func load(answer: String?, notificationState: NotificationState) -> Observable<QuestionDetails>
    func next() -> Observable<QuestionDetails>
    func previous() -> Observable<QuestionDetails>
    func updateAnswer(answer: String) -> Observable<QuestionDetails>
    func submit() -> Observable<QuestionDetails>
}

extension QuestionsInteractorType {
    func load() -> Observable<QuestionDetails> {
        return load(answer: nil, notificationState: .none)
    }
}

class QuestionsInteractor: QuestionsInteractorType {
    private let repository: QuestionsRepositoryType
    private var currentPage: Int
    private var totalPages: Int
    private var currentAnswer: String
    private var submittedQuestions = [Int: String]() // Current page & answer text accordingly
    
    deinit {
        print("♻️🚮 \(#file): \(#function)")
    }
    
    init(questionsRepository: QuestionsRepositoryType, currentPage: Int = 1, totalPages: Int = 1, currentAnswer: String = "") {
        print("♻️🆕 \(#file): \(#function)")
        self.repository = questionsRepository
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.currentAnswer = currentAnswer
    }
    
    func next() -> Observable<QuestionDetails> {
        if currentPage < totalPages {
            currentPage += 1
            return load()
        } else {
            return Observable.empty()
        }
    }
    
    func previous() -> Observable<QuestionDetails> {
        if currentPage > 1 && currentPage <= totalPages {
            currentPage -= 1
            return load()
        } else {
            return Observable.empty()
        }
    }
    
    func updateAnswer(answer: String) -> Observable<QuestionDetails> {
        self.currentAnswer = answer
        return load(answer: answer)
    }
    
    func submit() -> Observable<QuestionDetails> {
        let request = AnswerRequest(page: currentPage, answer: currentAnswer)
                
        return repository.submit(request: request)
            .flatMap { [weak self] isSucessful -> Observable<QuestionDetails> in
                guard let self = self else { return Observable.empty() }
                if isSucessful {
                    self.submittedQuestions[self.currentPage] = self.currentAnswer
                }
                let notificationState: NotificationState = isSucessful ? .sucessful : .failed
                return self.load(answer: self.currentAnswer, notificationState: notificationState)
        }
    }
    
    func load(answer: String? = nil, notificationState: NotificationState = .none) -> Observable<QuestionDetails> {
        let totalPagesObservable = repository.questions().map { $0.count }
        let questionsObservable =  repository.questions()
        
        return Observable.combineLatest(totalPagesObservable, questionsObservable)
            .flatMap { [weak self] totalPages, questions -> Observable<QuestionDetails> in
                guard let self = self else { return Observable.empty() }
                
                // Set variables
                self.totalPages = totalPages
                
                let buttonType: ButtonType
                let answeredQuestion: String
                if let answered = self.submittedQuestions[self.currentPage] {
                    buttonType = .submitted
                    answeredQuestion = answered
                } else if let answer = answer, answer.isValid {
                    buttonType = .submitEnabled
                    answeredQuestion = ""
                } else {
                    buttonType = .submitDisabled
                    answeredQuestion = ""
                }
                
                let questionDetails = questions
                    .filter { $0.identifier == self.currentPage }
                    .first
                    .map {
                        QuestionDetails(title: "Question \(self.currentPage)/\(totalPages)",
                            name: $0.name,
                            previousEnabled: self.previousEnabled(page: self.currentPage, totalPages: totalPages),
                            nextEnabled: self.nextEnabled(page: self.currentPage, totalPages: totalPages),
                            submittedQuestionsString: "Questions submitted: \(self.submittedQuestions.count)",
                            buttonType: buttonType,
                            answeredQuestion: answeredQuestion,
                            notificationState: notificationState)
                }
                guard let details = questionDetails else { return Observable.empty() }
                return Observable.just(details)
        }
    }
    
    func previousEnabled(page: Int, totalPages: Int) -> Bool {
        return page > 1 && page <= totalPages
    }
    
    func nextEnabled(page: Int, totalPages: Int) -> Bool {
        return page < totalPages
    }
}
