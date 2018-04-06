Pod::Spec.new do |s|

  s.name         = "Stefan"
  s.version      = "0.2.2"
  s.summary      = "Stefan - a guy that helps you to manage iOS data collections."

  s.homepage     = "https://github.com/appunite/Stefan"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.authors = { 'Szymon Mrozek' => 'szymon.mrozek.sm@gmail.com',
                'Piotr Bernad'  => 'http://bernad.paperplane.io' }

  s.platform     = :ios
  s.ios.deployment_target = '9.3'
  s.dependency "Differ", "~> 1.1.1"
  s.swift_version = "4.1"

  s.source       = { :git => "https://github.com/appunite/Stefan.git", :tag => "#{s.version}" }
  s.source_files  = "Stefan/**/*.swift"

end
