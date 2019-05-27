Pod::Spec.new do |s|
  s.name             = "EasyStash"
  s.summary          = "Easy data persistency in Swift"
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/onmyway133/EasyStash"
  s.license          = 'MIT'
  s.author           = { "Khoa Pham" => "onmyway133@gmail.com" }
  s.source           = {
    :git => "https://github.com/onmyway133/EasyStash.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/onmyway133'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '9.2'
  s.watchos.deployment_target = "4.0"

  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.tvos.source_files = 'Sources/{iOS,tvOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{macOS,Shared}/**/*'
  s.watchos.source_files = 'Sources/{watchOS,Shared}/**/*'

  s.swift_version = '5.0'
end
