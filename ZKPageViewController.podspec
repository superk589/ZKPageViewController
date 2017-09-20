Pod::Spec.new do |s|
  s.name         = "ZKPageViewController"
  s.version      = "0.0.4"
  s.summary      = "A PageViewController with a custom title view"
  s.description  = <<-DESC
                   A light-weighted PageViewController with a custom title view in swift.
                   DESC
  s.homepage     = "https://github.com/superk589/ZKPageViewController"
  s.license      = "MIT"
  s.author             = { "zhenkai zhao" => "superk589@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/superk589/ZKPageViewController.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.swift"
  s.framework  = "UIKit"
  s.dependency "SnapKit"
  s.dependency "DynamicColor"
end
