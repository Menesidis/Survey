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

    init(title: String = "Question -/-", previousButtonIsEnabled: Bool = false, nextButtonIsEnabled: Bool = true) {
        self.initialState = State(title: title, previousButtonIsEnabled: previousButtonIsEnabled, nextButtonIsEnabled: nextButtonIsEnabled)
    }
    
    enum Action {
        case load
    }

    enum Mutation {
        case testt
    }
    
    struct State {
        var title: String
        var previousButtonIsEnabled: Bool
        var nextButtonIsEnabled: Bool
    }
}
