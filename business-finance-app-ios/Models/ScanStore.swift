//
//  ScanStore.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import SwiftyAttributes

enum Disclaimer {
    case regulations
    
    var text: String {
        switch self {
        case .regulations:
            return "Ich bestätige die Einhaltung der gesetzlichen Regeln."
        }
    }
    
    var attributedText: NSAttributedString {
        switch self {
        case .regulations:
            return [
                "Ich bestätige die Einhaltung der "
                    .withFont(UIFont.systemFont(ofSize: 15, weight: .regular))
                    .withTextColor(UIColor.App.Text.dark),
                "gesetzlichen Regeln."
                    .withFont(UIFont.systemFont(ofSize: 15, weight: .regular))
                    .withTextColor(UIColor.App.Button.backgroundColor)
                    .withUnderlineColor(UIColor.App.Button.backgroundColor)
            ].merged()!
        }
    }
    static var all: [Disclaimer] {
        return [.regulations]
    }
}

struct ScanStore {
    private(set) var image: UIImage? {
        didSet {
//            guard let image = self.image else {
//                self.processedImage = nil
//                return
//            }
//
//            self.processedImage = image.blackAndWhite()
        }
    }
//    private(set) var processedImage: UIImage?
    private(set) var extraImages: [UIImage] = [] {
        didSet {
//            self.processedExtraImages = extraImages.map { $0.blackAndWhite() }
        }
    }
    
    private(set) var KidId : Int? {
        didSet {
            
        }
    }
//    private(set) var processedExtraImages: [UIImage] = []
    
    var product: Product?
    var kindergartenKid : KindergartenKid?
    var disabledProducts: [Product] = []
    var checkedDisclaimers: [Disclaimer] = []
    var benefitProductID: Int?
    var judgeKidView: Int?
    mutating func setExtraImages(_ images: [UIImage]) {
        self.extraImages = images
    }
    
    mutating func setImage(_ image: UIImage?) {
        self.image = image
    }

    mutating func setKidId(_ kidID :Int?){
        self.KidId = kidID
    }
    init(image: UIImage? = nil,
         extraImages: [UIImage] = [],
         product: Product? = nil,
         kindergartenKid: KindergartenKid? = nil,
         disabledProducts: [Product] = [],
         checkedDisclaimers: [Disclaimer] = [],
         benefitProductID :Int? = 0,
         judgeKidView :Int? = 0,
         kidDetails: Int? = 0) {
        self.image              = image
        self.extraImages        = extraImages
        self.product            = product
        self.kindergartenKid    = kindergartenKid
        self.disabledProducts   = disabledProducts
        self.checkedDisclaimers = checkedDisclaimers
        self.benefitProductID     = benefitProductID
        self.judgeKidView     = judgeKidView
        self.KidId         = kidDetails
    }
}
