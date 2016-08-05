Pod::Spec.new do |s|
  s.name         = "StudyplusSDK"
  s.version      = "2.0.3"
  s.summary      = "Studyplus iOS SDK"
  s.description  = <<-DESC
  Let's post learning records to Studyplus(https://studyplus.jp)
                   DESC
  s.homepage     = "http://info.studyplus.jp"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "studyplus" => "sutou@studyplus.jp" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/studyplus/Studyplus-iOS-SDK.git", :tag => s.version.to_s }
  s.source_files  = 'StudyplusSDK/**/*.{h,m}'
  s.public_header_files = 'StudyplusSDK/**/*.h'
  s.requires_arc = true

  s.dependency 'UICKeyChainStore', '1.0.4'
  s.dependency 'AFNetworking', '3.1.0'
end
