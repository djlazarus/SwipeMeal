platform :ios, '9.1'
use_frameworks!

target 'SwipeMeal' do

  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'

  pod 'SwiftSpinner'
  pod 'Branch'
  pod 'Stripe'
  pod 'AFNetworking'
  pod 'SwiftyUserDefaults'
  pod 'OneSignal'
  pod 'IncipiaKit',
        :git => 'https://github.com/Incipia/IncipiaKit.git',
            :branch => 'swift3'

end

post_install do |installer|
      installer.pods_project.targets.each do |target|
                  target.build_configurations.each do |config|
                                      config.build_settings['SWIFT_VERSION'] = '3.0'
                                                            end
                              end
end
