Pod::Spec.new do |s|
  s.name                  = "StudyplusSDK-V2"
  s.version               = "2.0.1"
  s.summary               = "StudyplusSDK-V2 is Studyplus iOS SDK for Swift"
  s.homepage              = "https://info.studyplus.jp"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.source                = { :git => "https://github.com/studyplus/Studyplus-iOS-SDK-V2.git", :tag => s.version }
  s.source_files          = "StudyplusSDK", "Lib/StudyplusSDK/**/*.{swift}"
  s.requires_arc          = true
  s.platform              = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.ios.frameworks        = ['UIKit', 'Foundation']
  s.author                = { 'Studyplus inc' => 'developer-all@studyplus.jp' }
  s.swift_versions        = ['4.2', '5.0']
end
