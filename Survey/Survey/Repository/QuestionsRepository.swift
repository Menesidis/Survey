//
//  QuestionsRepository.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Foundation
import RxSwift

protocol QuestionsRepositoryType: RepositoryType {
    func questions() -> Observable<[Question]>
    func submit(request: AnswerRequest) -> Observable<Bool>
}

class QuestionsRepository: QuestionsRepositoryType {

    private let client: HTTPClient
    private var questionsObservable: Observable<[Question]>?
    
    deinit {
        print("♻️🚮 \(#file): \(#function)")
    }

    init(httpClient: HTTPClient) {
        print("♻️🆕 \(#file): \(#function)")
        self.client = httpClient
    }

    func submit(request: AnswerRequest) -> Observable<Bool> {
        return requestSingle(client: client,
                             target: QuestionTarget.submit(request: request),
                             responseType: AnswerResponse.self,
                             errorType: AnswerErrorResponse.self)
    }
    
    //TODO: Should I replace  .concat(Observable.never())???
    func questions() -> Observable<[Question]> {
        guard let questions = questionsObservable else {
            questionsObservable = requestCollection(client: client,
                                                    target: QuestionTarget.questions,
                                                    responseType: [QuestionResponse].self,
                                                    errorType: QuestionErrorResponse.self)
                .concat(Observable.never())
                .share(replay: 1, scope: .whileConnected)
            return questionsObservable!
        }
        return questions
    }
}
