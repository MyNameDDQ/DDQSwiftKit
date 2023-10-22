#
#  Be sure to run `pod spec lint DDQSwiftKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'DDQSwiftKit'
  s.version          = '1.0.2'
  s.summary          = 'DDQKit swift version.'
  s.platform         = :ios, '9.0'
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.homepage         = 'https://github.com/MyNameDDQ/DDQSwiftKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MyNameDDQ' => '869795924@qq.com' }
  s.source           = { :git => 'https://github.com/MyNameDDQ/DDQSwiftKit.git', :tag => s.version.to_s }
  s.source_files = 'DDQSwiftKit/Classes/**/*'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 x86_64' }

  s.dependency 'SwiftyJSON'
  s.dependency 'HandyJSON'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'SwiftLint'
  s.dependency 'YYKit'
  s.dependency 'MBProgressHUD'
  s.dependency 'SAMKeychain'
  s.dependency 'SDWebImage'
  s.dependency 'MJRefresh'
  s.dependency 'AFNetworking'
  s.dependency 'FDFullscreenPopGesture'
  s.dependency 'SnapKit'
  s.dependency 'SwiftGen'
  s.dependency 'Kingfisher'
  s.dependency 'Alamofire'
end
