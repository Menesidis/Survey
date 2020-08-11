//
//  AppCoordinator.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import UIKit

public class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

    }
    
    func start() {
        let landingViewController = LandingViewController()
        landingViewController.delegate = self
        navigationController.show(landingViewController, sender: nil)
    }
    
    private func showQuestions() {
        let interactor = QuestionsInteractor()
        let reactor = QuestionReactor(interactor: interactor)
        let questionsViewController = QuestionViewController(reactor: reactor)
        navigationController.show(questionsViewController, sender: nil)
    }
}

extension AppCoordinator: LandingViewControllerDelegate {
    func landingViewControllerDidTapStartSurvey(landingViewController: LandingViewController) {
        showQuestions()
    }
}
