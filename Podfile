source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Jolty' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Realm', '3.11.0'
  pod 'RealmSwift', '3.11.0'
  pod 'SDWebImage', '~> 4.0'
  pod 'Kingfisher', '~> 4.9.0'
  pod 'SVProgressHUD'
  
  pod 'Alamofire', '~> 4.0'
  pod 'Alamofire-Synchronous', '~> 4.0'
  pod 'AlamofireImage', '~> 3.1'
  pod 'AlamofireOauth2'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'FirebaseCore'
  pod 'RAMAnimatedTabBarController', '~> 3.5.0'
  
  pod 'FBSDKCoreKit', '4.36.0'
  pod 'FBSDKLoginKit', '4.36.0'
  pod 'FacebookCore', '0.4'
  pod 'FacebookLogin', '0.4'
  
  #    pod 'FacebookCore', '0.3.1'
  #    pod 'FacebookLogin', '0.3.1'
  #    pod 'FacebookShare', '0.3.1'
  #    pod 'FBSDKLoginKit'
  #    pod 'FBSDKCoreKit'
  pod 'GoogleSignIn'
  pod 'GooglePlaces'
  
  pod 'RAMPaperSwitch', '2.1.0'
  pod 'Toast-Swift', '~> 3.0.1'
  
  pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
  
  pod 'lottie-ios', '2.5.0'
  pod 'TransitionButton', '0.5.1'
  pod 'BatteryView'
  
  pod 'SnapKit'
  pod 'BubbleTransition'
  pod 'IQKeyboardManager'
  pod 'AvatarImageView', '~> 2.1.0'
  pod 'GoogleAnalytics'
  
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'IQDropDownTextField'
  
  pod 'Crashlytics'
  pod 'ZAlertView'
  pod 'MaterialShowcase', '0.6.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end



