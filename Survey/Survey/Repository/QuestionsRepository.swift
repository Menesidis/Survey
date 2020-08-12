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
}

class QuestionsRepository: QuestionsRepositoryType {

    private let client: HTTPClient

    deinit {
        print("♻️🚮 \(#file): \(#function)")
    }

    init(httpClient: HTTPClient) {
        print("♻️🆕 \(#file): \(#function)")
        self.client = httpClient
    }

    func questions() -> Observable<[Question]> {
        return requestCollection(client: client,
                             target: QuestionTarget.questions,
                             responseType: [QuestionResponse].self,
                             errorType: QuestionErrorResponse.self)
    }
}
