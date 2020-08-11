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

class QuestionViewController: UIViewController {
    
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

        // Do any additional setup after loading the view.
    }
}
