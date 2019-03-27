#
#  Be sure to run `pod spec lint TLPageView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TLPageView"
  s.version      = "1.0"
  s.summary      = "PageView, 带左右定制 item"

  s.homepage     = "https://github.com/ysCharles/TLPageView"


  s.license      = "MIT"

  s.author             = { "Charles" => "ystanglei@gmail.com" }

  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/ysCharles/TLPageView.git", :tag => "#{s.version}" }




  s.source_files  = "Sources/**/*.swift"
  # s.resources = "Sources/**/*.xib"

  s.frameworks = "UIKit"
  s.swift_version = '5'

end
