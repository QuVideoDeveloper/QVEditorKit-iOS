#
# Be sure to run `pod lib lint QVEditorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QVEditorKit'
  s.version          = '1.0.71'
  s.summary          = 'A short description of QVEditorKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/QuVideoDeveloper/QVEditorKit-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sunshine' => 'cheng.xia@quvideo.com' }
  s.source           = { :git => 'https://github.com/QuVideoDeveloper/QVEditorKit-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.libraries = 'iconv', 'c', 'c++', 'stdc++', 'z'

  s.frameworks = 'VideoToolbox', 'Webkit', 'Photos', 'ImageIO', 'QuartzCore', 'AssetsLibrary', 'CoreGraphics' , 'Accelerate', 'UIKit', 'Foundation', 'AdSupport', 'CoreTelephony', 'CoreMedia', 'SceneKit', 'AudioToolbox'
  
  s.vendored_frameworks = 'QVEditorKit/FrameWork/*.framework'
  
  s.dependency 'ReactiveObjC'
  s.dependency 'FMDB'
  s.dependency 'YYModel'
  s.dependency 'SDWebImage'
  s.dependency 'XYCommonEngine'
  s.dependency 'SSZipArchive'
  s.dependency 'PromisesObjC'

  #s.dependency 'QVEngineKit'
 # s.dependency 'XYCommonEngine' , '0.1.0'

  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC" }
  s.xcconfig = { "ENABLE_BITCODE" => "NO" }

  # s.xcconfig = { "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" }
  # s.xcconfig = { "ENABLE_BITCODE" => "NO" }

  
  # s.resource_bundles = {
  #   'QVEditorKit' => ['QVEditorKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
