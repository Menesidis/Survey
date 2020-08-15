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
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
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
        
        retryButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        retryButton.titleLabel?.adjustsFontForContentSizeCategory = true
        retryButton.rounded(cornerRadius: 15.0)
        retryButton.setTitle("Retry", for: .normal)
        
        navigationItem.rightBarButtonItems = [nextBarButton, previousBarButton]
        view.backgroundColor = .gray
    }
    
    private func clearTextField() {
        answerTextField.text?.removeAll()
    }
    
    private func closeTextField() {
        answerTextField.resignFirstResponder()
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
            .map { [weak self] _ in
                self?.clearTextField()
                self?.closeTextField()
                return Reactor.Action.next
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        previousBarButton
            .rx
            .tap
            .map { [weak self] _ in
                self?.clearTextField()
                self?.closeTextField()
                return Reactor.Action.previous
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        answerTextField
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(answerTextField.rx.text.orEmpty)
            .map { Reactor.Action.updateAnswer(answer: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        retryButton
            .rx
            .tap
            .throttle(.milliseconds(2000), scheduler: MainScheduler.instance) //emits only the first item emitted by the source observable in the time window
            .map { [weak self] _ in
                self?.closeTextField()
                return Reactor.Action.submit
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        
        submitButton
            .rx
            .tap
            .throttle(.milliseconds(2000), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
                self?.closeTextField()
                return Reactor.Action.submit
        }
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
            .map {$0.submittedQuestionsString}
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
        
        reactorDriver
            .debounce(.milliseconds(2000)) // Ignore consecutive states for 2 sec
            .map {$0.notificationState}
            .drive(onNext: { [weak self] state in
                switch state {
                case .failed:
                    self?.resultLabel.text = "Failed"
                    self?.resultLabel.isHidden = false
                    self?.retryButton.isHidden = false
                    self?.animateNotificationView(state: state)
                    
                case .sucessful:
                    self?.resultLabel.text = "sucessful"
                    self?.resultLabel.isHidden = false
                    self?.retryButton.isHidden = true
                    self?.animateNotificationView(state: state)
                    
                case .none:
                    self?.resultLabel.isHidden = true
                    self?.retryButton.isHidden = true
                    self?.notificationView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        //TODO: Renaming!!!!
        //TODO: Validate everything again & business logic
    }
    
    private func animateNotificationView(state: NotificationState) {
        
        // Fade in animation
        self.notificationView.alpha = 0.0
        self.notificationView.isHidden = state.isHidden
        self.notificationView.backgroundColor = state.backgroundColor
        
        self.notificationView.fadeIn { [weak self] _ in
            guard let self = self else { return }
            self.view.bringSubviewToFront(self.notificationView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Fade out animation
                self.notificationView.fadeOut() {  _ in
                    self.notificationView.isHidden = !state.isHidden
                }
                
            }
        }
    }
}
