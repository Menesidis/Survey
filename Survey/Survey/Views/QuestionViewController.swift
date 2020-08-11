//
//  QuestionViewController.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class QuestionViewController: UIViewController {
    
    lazy var previousBarButton = UIBarButtonItem(title: "Previous", style: .done, target: self, action: nil)
    lazy var nextBarButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: nil)
    var disposeBag = DisposeBag()
    
    init(reactor: QuestionReactor) {
        print("♻️🆕 \(#file): \(#function)")

        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        previousBarButton.tintColor = .blue
        nextBarButton.tintColor = .blue
        navigationItem.rightBarButtonItems = [nextBarButton, previousBarButton]
    }
}

extension QuestionViewController: StoryboardView {
    
    typealias Reactor = QuestionReactor
    
    func bind(reactor: QuestionReactor) {
        
        // MARK: Actions
        Observable.just(Void())
            .map {Reactor.Action.load}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: States
        let reactorDriver = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
        
        reactorDriver
            .map {$0.previousButtonIsEnabled}
            .distinctUntilChanged()
            .drive(previousBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactorDriver
            .map {$0.nextButtonIsEnabled}
            .distinctUntilChanged()
            .drive(nextBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactorDriver
            .map {$0.title}
            .distinctUntilChanged()
            .drive(rx.title)
            .disposed(by: disposeBag)
    }
}
