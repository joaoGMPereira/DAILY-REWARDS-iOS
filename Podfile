use_frameworks!
platform :ios, '11.0'


def all_pods
  
  #MyJewThings
  #pod 'JewFeatures', :git => 'https://github.com/joaoGMPereira/JEW-FEATURE', :branch => 'master'
  pod 'JewFeatures', :path => '../JewFeatures'
  pod 'SwiftyRSA'
  
  #Security
  pod 'SwiftKeychainWrapper'
  
  #UIPods
  pod 'Hero', :git => 'https://github.com/barrault01/Hero.git', :commit => '6220387'
  pod 'lottie-ios'
  pod 'SkeletonView', :git => 'https://github.com/Juanpe/SkeletonView.git', :tag => '1.4.2'
  pod 'BetterSegmentedControl', '~> 1.1'
  pod 'StepView'
  pod 'ZCAnimatedLabel', :git => 'https://github.com/joaoGMPereira/ZCAnimatedLabel.git'
  pod 'CollectionKit'
  
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
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end

#target 'DailyRewardsDev' do
#  all_pods
#end
