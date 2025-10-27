platform :ios, '13.0'
#   supports_swift_versions '>= 4.2'

def crash_reporting
    pod 'Rollbar', "~> 1.10.0"
end 

def shared
  pod 'Alamofire', "~> 4.9.1"
  pod 'KeychainSwift', "~> 18.0.0"
  pod 'Localize-Swift', "~> 3.1.0"
  pod 'Kingfisher', "~> 5.10.1"
  pod 'SwiftyAttributes', "~> 5.1.1"
  pod 'Gloss', "~> 3.1.0"
  pod 'SwiftDate', "~> 6.1.0"
  pod 'Parchment', "~> 1.7.0"
  pod 'StatusProvider', "~> 1.2.10"
  pod 'SwiftyJSON', "~> 5.0.0"
  pod 'Device', "~> 3.2.1"
  pod 'AlamofireNetworkActivityLogger', '~> 2.4.0'
  pod 'SnapKit'
  pod 'FSCalendar'
  pod 'ANActivityIndicator'
  pod 'GooglePlaces'
  pod 'SwiftyJSON'
  pod 'DLRadioButton', '~> 1.4'
  pod 'RangeSeekSlider'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  crash_reporting
end

target 'BFA' do
  use_frameworks!
  inhibit_all_warnings!
  shared
end

target 'BFA STA' do
  use_frameworks!

  shared

end

target 'business-finance-app-iosTests' do
    inherit! :search_paths
end

target 'business-finance-app-iosUITests' do
    inherit! :search_paths
end
