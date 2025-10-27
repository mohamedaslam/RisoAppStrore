//
//  NotificationViewController.swift
//  NotificationContentAppExtension
//
//  Created by Mohammed Aslam Shaik on 2022/6/25.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var subTitleLabel: UILabel?
    @IBOutlet var bodyLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didReceive(_ notification: UNNotification) {
        self.titleLabel?.text = notification.request.content.title
        self.subTitleLabel?.text = notification.request.content.subtitle
        self.bodyLabel?.text = notification.request.content.body
    }

}
