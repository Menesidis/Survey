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
    }
}
