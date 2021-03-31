Pod::Spec.new do |s|
  s.name                  = "StudyplusSDK-V2"
  s.version               = "3.0.0"
  s.summary               = "StudyplusSDK-V2 is Studyplus iOS SDK for Swift"
  s.homepage              = "https://info.studyplus.jp"
  s.license               = "MIT"
  s.source                = { :git => "https://github.com/studyplus/Studyplus-iOS-SDK-V2.git", :tag => s.version }
  s.source_files          = "StudyplusSDK", "Lib/StudyplusSDK/**/*.{swift}"
  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { 'Studyplus inc' => 'developer-all@studyplus.jp' }
  s.swift_versions        = ['5.1', '5.2', '5.3']
end
