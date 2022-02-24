# Forethought Plugins

When you want to hand off your Forethought chat to a live agent, you have two choices:

1. Implement the handoff yourself, or
2. Use a pre-made plugin that handles all of the logic for you

All Forethought Plugins are open-source and customizable. You'll still be able to access the containing frameworks, and if you'd like, you can download the plugin file and further customize it yourself.

## Installation

### Swift Package Manager

Installing with Swift Package Manager will follow the same steps as installing the Forethought SDK itself. After you choose "Add Package" you should see a list of available plugins to optionally install. Choose the plugin that's correct for you, and it will be installed automatically.


### Cocoapods

1. Forethought is also available through [CocoaPods](http://cocoapods.org). If you have not yet installed Cocoapods, follow their guide to install and create a Podfile [here](https://guides.cocoapods.org/using/getting-started.html).  

1. In your Podfile, add the corresponding line to the plugin you're looking for:
   ```ruby
   #For Zendesk
   pod 'ForethoughtPlugins/ZendeskPlugin'

   #For Kustomer
   pod 'ForethoughtPlugins/KustomerPlugin'

   ```
1. Run the following command:
   ```
   $ pod install
   ```
   
##  Usage
To attach your Plugin to Forethought, make the following changes to your AppDelegate.swift file:


Zendesk:

   ```swift
	 let plugin = ZendeskPlugin(accountKey: "ZENDESK_KEY", appId: "ZENDESK_ID")
	 ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__", plugins: [plugin])
   ```

Kustomer:

   ```swift
	 let plugin = KustomerPlugin(apiKey: "__KUSTOMER_API_KEY__", options: nil)
	 ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__", plugins: [plugin])
   ```


And that's it! To further customize, feel free to check out the source code in the plugins/ directory. Each plugin has options for further customization.