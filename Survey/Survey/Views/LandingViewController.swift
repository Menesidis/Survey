//
//  LandingViewController.swift
//  Survey
//
//  Created by Menesidis on 11/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import UIKit

// Class protocol could be adopted only by class object types
protocol LandingViewControllerDelegate: class {
    func landingViewControllerDidTapStartSurvey(landingViewController: LandingViewController)
}

class LandingViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    weak var delegate: LandingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.text = "Welcome to survey app"
        
        startButton.setTitle("Start survey", for: .normal)
        startButton.backgroundColor = .white
        startButton.setTitleColor(.blue, for: .normal)
        startButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        startButton.titleLabel?.adjustsFontForContentSizeCategory = true
        startButton.rounded(cornerRadius: 15.0, borderColor: .blue, borderWidth: 0.5)
    }
    
    // MARK - Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        delegate?.landingViewControllerDidTapStartSurvey(landingViewController: self)
    }
}
