Pod::Spec.new do |spec|

    spec.name               = "Forethought"
    spec.version            = "2.0.0"
    spec.summary            = "Transform customer service with human-centered AI"
    spec.description        = "Transform customer service with human-centered AI using the Forethought Solve AI Chatbot"
    spec.homepage           = "https://forethought.ai"
    spec.license            = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
    spec.author             = { "Forethought Engineering" => "eng@forethought.ai" }
    spec.social_media_url   = "https://twitter.com/forethought_ai"
    spec.platform           = :ios, "11.0"
    spec.swift_version      = '5.0'
    spec.source             = { :git => "https://github.com/Forethought-Technologies/solve-ios.git", :tag => "#{spec.version}" }
    
    spec.vendored_frameworks = "Forethought.xcframework"

end
