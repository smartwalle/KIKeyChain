Pod::Spec.new do |s|
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
  s.license      = "MIT"
  s.author       = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/smartwalle/KIKeyChain.git", :tag => "0.1" }
  s.source_files  = "KIKeyChain/KIKeyChain/*.{h,m}"
  s.framework  = "Security"
  s.requires_arc = true
end
