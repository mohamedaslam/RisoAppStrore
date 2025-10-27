//
//  OnboardingViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

struct OnboardingPage: Equatable {
    let image: UIImage?
    let titleText: String
    let detailsText: String
}

extension OnboardingPage {
    static func getOnboardingPages() -> [OnboardingPage] {
        return Array(0...2).map {
            OnboardingPage(
                image: UIImage(named: "tutorial.page\($0).image"),
                titleText: "tutorial.page\($0).title".localized,
                detailsText: "tutorial.page\($0).details".localized
            )
        }
    }
}

extension OnboardingViewController {
    static func instantiate(with page: OnboardingPage) -> OnboardingViewController {
        let storyboard = UIStoryboard(storyboard: .onboarding)
        let vc: OnboardingViewController = storyboard.instantiateViewController()
        vc.page = page
        return vc
    }
}

class OnboardingViewController: BaseViewController {
    private var page: OnboardingPage?
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel?.textColor = UIColor.App.Text.dark
            titleLabel?.font = UIFont.appFont(ofSize: 15, weight: .semibold)
        }
    }
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel?.textColor = UIColor.App.Text.light
            detailsLabel?.font = UIFont.appFont(ofSize: 15, weight: .regular)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textsContainerView: UIView!
}

extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        titleLabel.text   = page?.titleText
        detailsLabel.text = page?.detailsText
        imageView.image   = page?.image
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textsContainerView.set(shadowType: .subtle)
    }
}
