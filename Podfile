platform :ios, '7.0'

target :StudyplusSDK do
    pod 'UICKeyChainStore', '1.0.4'
    pod 'AFNetworking', '3.1.0'
end

target :StudyplusSDKTests do
    pod 'Kiwi/XCTest', '2.2.3'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
