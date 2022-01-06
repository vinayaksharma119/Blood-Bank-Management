# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'Blood Bank' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Blood Bank
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'IQKeyboardManagerSwift'
  pod 'lottie-ios'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end
