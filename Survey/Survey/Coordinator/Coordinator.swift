//
//  Coordinator.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
