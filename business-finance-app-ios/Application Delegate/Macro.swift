//
//  Macro.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/6/28.
//  Copyright © 2022 Rate Rebriduo. All rights reserved.
//

import UIKit


let PreventRepeatedPressesSec = 0.5
let IsIpad: Bool = UIDevice.current.model == "iPad"
let IsSmallScreen: Bool = UIScreen.main.bounds.size.width <= 320.0
let Screen_Width = IsIpad ? 320.0 : UIScreen.main.bounds.size.width
let Screen_Height = IsIpad ? 431.0 : UIScreen.main.bounds.size.height
let Iphone_4_7_Inch_Width = 375.0
let Iphone_4_7_Inch_Height = 667.0
let AutoSizeScaleX = Screen_Width / CGFloat(Iphone_4_7_Inch_Width)
let AutoSizeScaleY = Screen_Height / CGFloat(Iphone_4_7_Inch_Height)
public func AutoSizeScale(_ length: CGFloat) -> CGFloat {
    return (length / Iphone_4_7_Inch_Width * (Screen_Width > Screen_Height ? Screen_Height : Screen_Width))
}
let NavigationBar_Height = UIApplication.shared.statusBarFrame.size.height + 44.0
let StatusBar_Height = UIApplication.shared.statusBarFrame.size.height
let SafeAreaInsets_Bottom = UIApplication.shared.statusBarFrame.size.height > 20.0 ? CGFloat(34.0) : CGFloat(0.0)
let TabBar_Height = 49.0
let NavigationBarBtn_Width = 30.0
let NavigationBarBtn_Height = 44.0
let NavigationBarBtn_IntervalWidth = 10.0
let NavigationBarTitleView_Height = 44.0
let ITUIApplicationDelegate = UIApplication.shared.delegate as! AppDelegate
let ITNSUserDefaults = UserDefaults.standard
let LoginRememberMeClick = "RememberMe"
let isLogout = "isLogout"
let ImgStr = "ImgStr"
let ObjectKey = "ObjectKey"
let TextInputModeStr = "zh-Hans"
let deviceTokenStore = "DeviceToken"

