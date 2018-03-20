Pod::Spec.new do |s|

  s.name         = "Stefan"
  s.version      = "0.2.0"
  s.summary      = "Stefan - a guy that helps you to manage iOS data collections."

  s.homepage     = "http://github.com/appunite/Stefan"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.authors = { 'Szymon Mrozek' => 'szymon.mrozek.sm@gmail.com',
                'Piotr Bernad'  => 'http://bernad.paperplane.io' }

  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.dependency "Differ", "~> 1.0.3"

  s.source       = { :git => "http://github.com/appunite/Stefan.git", :tag => "#{s.version}" }
  s.source_files  = "Stefan/**/*.swift"

end
