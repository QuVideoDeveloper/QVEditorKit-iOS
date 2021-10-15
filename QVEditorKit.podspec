#
# Be sure to run `pod lib lint QVEditorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QVEditorKit'
  s.version          = '1.1.27'
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
  

#公共Class

s.subspec 'Core' do |ce|
      ce.vendored_frameworks = 'QVEditorKit/FrameWork/Core/*.framework'
        ce.dependency 'ReactiveObjC'

end

s.subspec 'Editor' do |ed|
  ed.vendored_frameworks = 'QVEditorKit/FrameWork/Editor/*.framework'
  ed.dependency 'FMDB'
  ed.dependency 'YYModel'
  ed.dependency 'SDWebImage'
  ed.dependency 'XYCommonEngine'
  ed.dependency 'SSZipArchive'
  ed.dependency 'PromisesObjC'
end

  
  

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
