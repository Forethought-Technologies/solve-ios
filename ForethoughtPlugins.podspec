$FORETHOUGHT_VERSION = "1.0.0"

Pod::Spec.new do |spec|

  spec.name         = "ForethoughtPlugins"
  spec.version      = $FORETHOUGHT_VERSION
  spec.summary      = "Connect Forethought to various other live-chat platforms"
  spec.description  = "Connect Forethought to various other live-chat platforms, such as ZenDesk or Kustomer"
  spec.homepage     = "https://forethought.ai"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }

  spec.author             = { "Forethought Engineering" => "eng@forethought.ai" }
  spec.social_media_url   = "https://twitter.com/forethought_ai"

  spec.platform     	= :ios, "11.0"
	spec.swift_version 	= '5.0'

  spec.source       = { :git => "https://github.com/Forethought-Technologies/solve-ios.git", :tag => $FORETHOUGHT_VERSION }

  spec.dependency "Forethought", $FORETHOUGHT_VERSION
  
  spec.subspec "ZendeskPlugin" do |ss|
  	ss.source_files = "Plugins/Zendesk/*.swift"
		ss.dependency 'ZendeskChatSDK', '~> 3.0'
  end
	
  spec.subspec "KustomerPlugin" do |ss|
  	ss.source_files = "Plugins/Kustomer/*.swift"
		ss.dependency 'KustomerChat', '~> 2.7'
  end
  
  spec.subspec "IntercomPlugin" do |ss|
  	ss.source_files = "Plugins/Intercom/*.swift"
		ss.dependency 'Intercom', '~> 14.0'
  end

end
