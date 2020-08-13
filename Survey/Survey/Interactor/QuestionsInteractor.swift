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
    func load(page: Int) -> Observable<QuestionDetails>
    func next() -> Observable<QuestionDetails>
    func previous() -> Observable<QuestionDetails>
    func updateAnswer(answer: String) -> Observable<QuestionDetails>
}

extension QuestionsInteractorType {
    func load() -> Observable<QuestionDetails> {
        return load(page: 1)
    }
}

class QuestionsInteractor: QuestionsInteractorType {
    private let repository: QuestionsRepositoryType
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    
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
    
    //TODO: Check multiple API calls!
    //TODO: Update mapping logic
    func load(page: Int) -> Observable<QuestionDetails> {
        let totalPagesObservable = repository.questions().map { $0.count }
        let questionsObservable =  repository.questions()
        
        return Observable.combineLatest(totalPagesObservable, questionsObservable)
            .flatMap { [unowned self] totalPages, questions -> Observable<QuestionDetails> in

                // Set variables
                self.totalPages = totalPages
                self.currentPage = page
                
                let questionDetails = questions
                    .filter { $0.identifier == page }
                    .first.map {
                        QuestionDetails(title: "Question \(page)/\(totalPages)",
                            name: $0.name,
                            previousEnabled: (page > 1 && page <= totalPages),
                            nextEnabled: page < totalPages,
                            submittedQuestions: "Questions submitted: 0",
                            buttonType: .disabled(text: "Submit"))
                }
                
                guard let details = questionDetails else { return Observable.empty() }
                return Observable.just(details)
        }
    }
}
