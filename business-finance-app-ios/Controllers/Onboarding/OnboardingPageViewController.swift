//
//  OnboardingPageViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    private var pages             : [OnboardingPage]   = []
    private var screens           : [UIViewController] = []
    private var currentPageNumber : Int                = 0
    private var canDismiss        : Bool               = false
    let pageControl : UIPageControl = {
        let control                                       = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor                    = UIColor.App.PageIndicator.default
        control.currentPageIndicatorTintColor             = UIColor.App.PageIndicator.selected
        return control
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.App.primary
        return view
    }()
    let titleLabel: UILabel = {
        let label           = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor     = .white
        label.font          = UIFont.appFont(ofSize: 20, weight: .semibold)
        return label
    }()

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {

        super.init(transitionStyle: style,
                   navigationOrientation: navigationOrientation,
                   options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(pages: [OnboardingPage], canDismiss: Bool) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pages = pages
        self.canDismiss = canDismiss
    }
}

extension OnboardingPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        screens = pages.map { OnboardingViewController.instantiate(with: $0) }
        delegate = self
        
        if !pages.isEmpty {
            if pages.count > 1 {
                dataSource = self
            }
            let page = 0
            self.currentPageNumber = page
            setViewControllers([screenForPageNumber(page)], direction: .forward, animated: false, completion: nil)
            pageControl.currentPage = page
        }
        
        pageControl.numberOfPages = screens.count
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bottomRatio: CGFloat = 0.4
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height * bottomRatio))
        ])
    }
    private func setupViews() {
        view.backgroundColor = UIColor.App.Controller.grayBackground
        
        view.insertSubview(backgroundView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.lastBaselineAnchor.constraint(equalTo: view.topAnchor, constant: 42),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
            ])
        if let profile = ApplicationDelegate.client.loggedUser {
            titleLabel.text = String(format: "tutorial.welcome".localized, profile.name)
        }
        
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
        
        if canDismiss {
            let skipButton = UIBarButtonItem(
                title: "tutorial.skip".localized,
                style: .plain,
                target: self,
                action: #selector(skipButtonDidTouch)
            )
            navigationItem.rightBarButtonItem = skipButton
        }
    }
    
    @objc
    func pageControlValueChanged(_ control: UIPageControl) {
        let direction: UIPageViewController.NavigationDirection = control.currentPage > currentPageNumber ? .forward : .reverse
        self.setViewControllers([screenForPageNumber(control.currentPage)], direction: direction, animated: true, completion: nil)
        currentPageNumber = control.currentPage
    }
    
    @objc
    func skipButtonDidTouch() {
        ApplicationDelegate.client.skipTutorial()
    }
    
    private func screenForPageNumber(_ pageNumber: Int) -> UIViewController {
        guard (0..<screens.count).contains(pageNumber) else { return UIViewController() }
        return screens[pageNumber]
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = pageViewController.viewControllers?.first, let index = screens.firstIndex(of: viewController) else {
            return nil
        }
        currentPageNumber = index
        if currentPageNumber < screens.count-1 {
            currentPageNumber += 1
            return screenForPageNumber(currentPageNumber)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = pageViewController.viewControllers?.first, let index = screens.firstIndex(of: viewController) else {
            return nil
        }
        currentPageNumber = index
        if currentPageNumber > 0 {
            currentPageNumber -= 1
            return screenForPageNumber(currentPageNumber)
        }
        return nil
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        let currentPage = screens.firstIndex(of: pageViewController.viewControllers![0]) ?? 0
        pageControl.currentPage = currentPage
    }
}

