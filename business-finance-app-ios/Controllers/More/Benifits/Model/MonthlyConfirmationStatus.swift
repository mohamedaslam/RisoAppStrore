//
//  MonthlyConfirmationStatus.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/5.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct MonthlyConfirmationStatus: Equatable, Hashable {
    let is_need_initial_setup : Int
    let is_need_monthly_confirmation : Int
    let is_need_initial_setup_for_kinder : Int
    let is_need_monthly_confirmation_for_kinder : Int
}


extension MonthlyConfirmationStatus: JSONDecodable {
    init?(json: JSON) {
        self.is_need_initial_setup = "is_need_initial_setup" <~~ json ?? 0
        self.is_need_monthly_confirmation = "is_need_monthly_confirmation" <~~ json ?? 0
        self.is_need_initial_setup_for_kinder = "is_need_initial_setup_for_kinder" <~~ json ?? 0
        self.is_need_monthly_confirmation_for_kinder = "is_need_monthly_confirmation_for_kinder" <~~ json ?? 0
    }
}


