#
#  Be sure to run `pod spec lint TSNetwork.podspec' to ensure this is a
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

  s.name         = "TSVerificationText"
  s.version      = "1.0.5"
  s.summary      = "A VerificationText Demo"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    TSVerificationText textfieldc测试DemoPod 
                   DESC

  s.homepage     = "http://www.baidu.com"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  #s.license      = "MIT (example)"
   s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "wujiamingcq" => "wujiaming@caiqr.com" }


  s.platform     = :ios, "9.0"

  s.source       = { :git => "http://gitlab.caiqr.com/ios_module/TSVerificationTextfield.git", :tag => "#{s.version}" }

  s.source_files  = "TSTextfield/*"

  s.swift_version = '4.0'

  s.requires_arc = true
  s.dependency 'TSCustomUIKit'

end
