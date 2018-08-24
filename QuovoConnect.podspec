Pod::Spec.new do |s|
  s.name             = 'QuovoConnect'
  s.version          = '0.6.1'
  s.summary          = 'Quovo Connect Swift SDK'

  s.description      = <<-DESC
connect-ios is a valuable, easy-to-use swift SDK that you can use to embed Quovo Connect into your mobile apps to help your users link their financial accounts. Connect integrates with the rest of Quovo’s API suite, providing a seamless and user-friendly sync process.
                       DESC

  s.homepage         = 'https://github.com/Quovo/connect-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Quovo' => 'info@quovo.com' }
  s.source           = { :git => 'https://github.com/Quovo/connect-ios.git', :tag => "v#{s.version.to_s}" }

  s.platform = :ios, '8.0'
  s.ios.vendored_frameworks = 'QuovoConnectSDK.framework'
end
