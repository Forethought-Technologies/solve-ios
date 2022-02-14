$FORETHOUGHT_VERSION = "0.2.0"

Pod::Spec.new do |spec|

  spec.name         = "ForethoughtPlugins"
  spec.version      = $FORETHOUGHT_VERSION
  spec.summary      = "Connect Forethought to various other live-chat platforms"
  spec.description  = "Connect Forethought to various other live-chat platforms, such as ZenDesk or Kustomer"
  spec.homepage     = "https://forethought.ai"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  spec.author             = { "Matthew Knippen" => "matthew@zwiffer.com" }
  # spec.authors            = { "Matthew Knippen" => "matthew@zwiffer.com" }
  spec.social_media_url   = "https://twitter.com/forethought_ai"

  spec.platform     	= :ios, "11.0"
	spec.swift_version 	= '5.0'

  spec.source       = { :git => "https://github.com/Forethought-Technologies/solve-ios.git", :tag => $FORETHOUGHT_VERSION }

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  spec.dependency "Forethought", $FORETHOUGHT_VERSION
  
  spec.subspec "KustomerPlugin" do |ss|
  	ss.source_files = "Plugins/Kustomer/*.swift"
		ss.dependency 'KustomerChat', '~> 2.4.11'
  end

end
