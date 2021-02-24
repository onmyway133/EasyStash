Pod::Spec.new do |s|
  s.name             = "EasyStash"
  s.summary          = "Easy data persistence in Swift"
  s.version          = "1.1.8"
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
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = "5.0"

  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*'
  s.tvos.source_files = 'Sources/**/*'
  s.osx.source_files = 'Sources/**/*'
  s.watchos.source_files = 'Sources/**/*'

  s.swift_version = '5.0'
end
