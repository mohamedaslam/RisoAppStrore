//
//  Globals.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 26/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation
//import ImagePicker
//
//let cameraConfiguration: Configuration = {
//    var config = Configuration()
//    config.doneButtonTitle = "Done".localized
//    config.noImagesTitle = ""
//    config.recordLocation = false
//    config.allowVideoSelection = false
//    config.allowMultiplePhotoSelection = true
//    config.collapseCollectionViewWhileShot = true
//    return config
//}()

func minmax<T: Comparable>(_ lowerLimit: T, _ value: T, _ upperLimit: T) -> T {
    return min(max(lowerLimit, value), upperLimit)
}
