#
#  Be sure to run `pod spec lint DSBaseViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DSBaseViewController"
  s.version      = "1.5.2"
  s.summary      = "A serial of super view controller classes."

  s.description  = <<-DESC
DSBaseViewController brings the convenience for your view controllers to maintain the subviews' construction and data source management, it extends a core protocol with overriding methods of UIViewController, conforming the protocol for the subclasses will get the beautiful magic.
                   DESC

  s.homepage     = "http://github.com/xingheng/DSBaseViewController"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Will Han" => "xingheng.hax@qq.com" }
  s.social_media_url   = "https://twitter.com/xingheng907"

  s.platform     = :ios

  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/xingheng/DSBaseViewController.git", :tag => s.version.to_s }

  s.source_files  = "DSBaseViewController", "DSBaseViewController/**/*.{h,m}"
  s.public_header_files = "DSBaseViewController/**/*.h"

  s.frameworks = "UIKit"
  s.requires_arc = true

end
