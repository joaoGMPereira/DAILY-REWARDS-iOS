use_frameworks!
platform :ios, '11.0'


def all_pods
  
  #MyJewThings
  #pod 'JewFeatures', :git => 'https://github.com/joaoGMPereira/JEW-FEATURE', :branch => 'master'
  pod 'JewFeatures', :path => '../JEW-FEATURE'
  
  
  #Security
  pod 'SwiftKeychainWrapper'
  pod 'SwiftyRSA'
  pod 'CryptoSwift'
  #UIPods
  pod 'Hero'
  pod 'lottie-ios'
  pod 'SkeletonView'
  pod 'BetterSegmentedControl'
  pod 'StepView'
  pod 'ZCAnimatedLabel', :git => 'https://github.com/joaoGMPereira/ZCAnimatedLabel.git'
  pod 'CollectionKit'
  pod 'JTAppleCalendar'
  
  #Resquests
  pod 'Alamofire'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
end

target 'DailyRewards' do
  all_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end

#target 'DailyRewardsDev' do
#  all_pods
#end
