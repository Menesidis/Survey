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
    func load(page: Int, answer: String?, notificationState: NotificationState) -> Observable<QuestionDetails>
    func next() -> Observable<QuestionDetails>
    func previous() -> Observable<QuestionDetails>
    func updateAnswer(answer: String) -> Observable<QuestionDetails>
    func submit() -> Observable<QuestionDetails>
}

extension QuestionsInteractorType {
    func load() -> Observable<QuestionDetails> {
        return load(page: 1, answer: nil, notificationState: .none)
    }
}

class QuestionsInteractor: QuestionsInteractorType {
    private let repository: QuestionsRepositoryType
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private var submittedQuestions = [Int: String]() // Current page & answer text accordingly
    
    deinit {
        print("♻️🚮 \(#file): \(#function)")
    }
    
    init(questionsRepository: QuestionsRepositoryType) {
        print("♻️🆕 \(#file): \(#function)")
        self.repository = questionsRepository
    }
    
    func next() -> Observable<QuestionDetails> {
        if currentPage < totalPages {
            currentPage += 1
            return load(page: currentPage)
        } else {
            return Observable.empty()
        }
    }
    
    func previous() -> Observable<QuestionDetails> {
        if currentPage > 1 && currentPage <= totalPages {
            currentPage -= 1
            return load(page: currentPage)
        } else {
            return Observable.empty()
        }
    }
    
    func submit() -> Observable<QuestionDetails> {
        
        guard let answer = currentAnswer else { return Observable.empty() }
        let request = AnswerRequest(page: currentPage, answer: answer)
                
        return repository.submit(request: request)
            .flatMap { [unowned self] isSucessful -> Observable<QuestionDetails> in
                if isSucessful {
                    self.submittedQuestions[self.currentPage] = answer
                }
                let notificationState: NotificationState = isSucessful ? .sucessful : .failed
                return self.load(page: self.currentPage, answer: answer, notificationState: notificationState)
        }
    }
    
    //TODO: Check multiple API calls!
    //TODO: Update mapping logic
    func load(page: Int, answer: String? = nil, notificationState: NotificationState = .none) -> Observable<QuestionDetails> {
        let totalPagesObservable = repository.questions().map { $0.count }
        let questionsObservable =  repository.questions()
        
        return Observable.combineLatest(totalPagesObservable, questionsObservable)
            .flatMap { [unowned self] totalPages, questions -> Observable<QuestionDetails> in

                // Set variables
                self.totalPages = totalPages
                self.currentPage = page
               
                let buttonType: ButtonType
                let answeredQuestion: String
                
                if let answered = self.submittedQuestions[page] {
                    buttonType = .submitted(text: "Already submited!")
                    answeredQuestion = answered
                } else if let answer = answer, answer.count > 0 {
                    buttonType = .submit(text: "Submit")
                    answeredQuestion = ""
                } else {
                    buttonType = .disabled(text: "Submit")
                    answeredQuestion = ""
                }
                
                let questionDetails = questions
                    .filter { $0.identifier == page }
                    .first.map {
                        QuestionDetails(title: "Question \(page)/\(totalPages)",
                            name: $0.name,
                            previousEnabled: (page > 1 && page <= totalPages),
                            nextEnabled: page < totalPages,
                            submittedQuestions: "Questions submitted: \(self.submittedQuestions.count)", //TODO: Check self!
                            buttonType: buttonType,
                            answeredQuestion: answeredQuestion,
                            notificationState: notificationState)
                }
                
                guard let details = questionDetails else { return Observable.empty() }
                return Observable.just(details)
        }
    }
}
