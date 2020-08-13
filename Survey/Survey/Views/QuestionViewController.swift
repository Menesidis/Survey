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
    
    @IBOutlet weak var submittedQuestionsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
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
        //TODO: Add Scroll view????
        
        answerTextField.delegate = self
        answerTextField.textColor = .lightGray
        answerTextField.placeholder = "Type here for an answer..."
        answerTextField.font = UIFont.preferredFont(forTextStyle: .title2)
        answerTextField.adjustsFontForContentSizeCategory = true
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.adjustsFontForContentSizeCategory = true
        
        submittedQuestionsLabel.textColor = .black
        submittedQuestionsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        submittedQuestionsLabel.adjustsFontForContentSizeCategory = true
        submittedQuestionsLabel.backgroundColor = .white
        
        submitButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        submitButton.titleLabel?.adjustsFontForContentSizeCategory = true
        submitButton.rounded(cornerRadius: 15.0)
        
        navigationItem.rightBarButtonItems = [nextBarButton, previousBarButton]
        view.backgroundColor = .gray
    }
}

extension QuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
        
       nextBarButton
            .rx
            .tap
            .map {Reactor.Action.next}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        previousBarButton
             .rx
             .tap
             .map {Reactor.Action.previous}
             .bind(to: reactor.action)
             .disposed(by: disposeBag)
                
        answerTextField
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(answerTextField.rx.text.orEmpty)
            .map { Reactor.Action.updateAnswer(answer: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        submitButton
             .rx
             .tap
             .map {Reactor.Action.submit}
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
        
        reactorDriver
            .map {$0.name}
            .distinctUntilChanged()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactorDriver
            .map {$0.submittedQuestions}
            .distinctUntilChanged()
            .drive(submittedQuestionsLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactorDriver
            .map {$0.buttonType}
            .drive(submitButton.rx.buttonType)
            .disposed(by: disposeBag)
        
        reactorDriver
            .map {$0.answeredText}
            .distinctUntilChanged()
            .drive(answerTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        //TODO: Close textfield before performing submit request
        //TODO: Clear textfield during next or previous
        //TODO: Renaming!!!!
        //TODO: Validate everything again & business logic
    }
}
