#
#  Be sure to run `pod spec lint KIKeyChain.podspec' to ensure this is a
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

  s.name         = "KIKeyChain"
  s.version      = "0.1"
  s.summary      = "快速访问 KeyChain 的组件。"

  s.description  = <<-DESC
                   ## KIKeyChain

                  在 iOS 应用程序开发过程中，我们经常会存储一些比较重要的信息。比如涉及到用户系统的 App, 我们就需要考虑自动登录的功能，如果把用户的用户名和密码存储在 NSUserDefault 中，会很不安全。第一，该信息是明文存储的；第二，可以通过一些工具获取到 NSUserDefault 中的信息。这样就很容易泄露用户的账号信息，这当然是我们不愿意看到的。

                  出于安全方面的考虑，Apple 为我们提供了一个叫 KeyChain 的工具, 存储在里面的信息不能说绝对安全，但是相对于 NSUserDefault 或者其它一些存储在 App 沙盒中的信息，其要安全很多。第一，KeyChain 的存储位置位于 /private/var/Keychains/... ，如果我们要直接访问里面的信息，必须要先越狱之后才能访问；第二，KeyChain 的关键信息都是经过加密处理的，所以就算获取到之后也还需要做破解工作。

                  网上有很多关于 KeyChain 的访问组件，Apple 也提供了相应的 [Demo](https://developer.apple.com/library/ios/samplecode/GenericKeychain/Introduction/Intro.html)。但是，感觉不怎么实用，操作起来相对麻烦。所以决定自己对其重新进行封装，然后就有了这个 KIKeyChain 这个组件。

                  使用方法如下：

                  写入数据：

                      KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_user"];
                      [key setValue:@"user1" forKey:@"username"];
                      [key setValue:@"password1" forKey:@"password"];
                      [key write];

                  读取数据：

                      KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_user"];
                      NSLog(@"%@==%@", [key valueForKey:@"username"], [key valueForKey:@"password"]);

                   DESC

  s.homepage     = "https://github.com/smartwalle/KIKeyChain"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => 'Apache License, Version 2.0', :file => 'COPYING' }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "SmartWalle" => "smartwalle@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/smartwalle/KIKeyChain.git", :tag => "0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "KIKeyChain/KIKeyChain/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
