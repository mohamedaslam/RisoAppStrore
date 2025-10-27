//
//  PagingViewController+Factory.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Parchment

extension PagingViewController {
    class func create() -> PagingViewController {
        let pagingViewController                     = PagingViewController()
        pagingViewController.textColor               = UIColor.white.alpha(0.3)
        pagingViewController.selectedTextColor       = .white
        pagingViewController.font                    = UIFont.appFont(ofSize: 13, weight: .medium)
        pagingViewController.selectedFont            = UIFont.appFont(ofSize: 15, weight: .medium)
        pagingViewController.selectedScrollPosition  = .center
        pagingViewController.indicatorColor          = .clear
        pagingViewController.borderColor             = UIColor.App.primary
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.menuBackgroundColor     = UIColor.App.primary
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.menuInsets              = UIEdgeInsets.init(top: 13, left: 0, bottom: 13, right: 0)
        pagingViewController.menuTransition          = .scrollAlongside
        pagingViewController.menuInteraction         = .swipe
        pagingViewController.menuItemSize            = PagingMenuItemSize.sizeToFit(minWidth: 180 * AutoSizeScaleX,
                                                                                    height: 40)
        return pagingViewController
    }
}
