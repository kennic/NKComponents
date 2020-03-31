Pod::Spec.new do |s|
  s.name             = 'NKComponents'
  s.version          = '1.0'
  s.summary          = 'A set of UI components'
  s.description      = <<-DESC
A set of UI components:
- NKTextField
- NKTextView
- NKImageView
- NKIconLabel
- NKGridLineView
                       DESC

  s.homepage         = 'https://github.com/kennic/NKComponents'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nam Kennic' => 'namkennic@me.com' }
  s.source           = { :git => 'https://github.com/kennic/NKComponents.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/namkennic'
  s.platform          = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  
  s.source_files = 'NKComponents/*.swift'
  s.frameworks = 'UIKit'
  
end
