# Forethought - Solve iOS SDK

This repository contains the framework and instructions for the Forethought iOS SDK.

You will need a valid API key in order to use the Forethought Solve SDK. In additon to the instructions below, you can also view sample apps written in Objective-C & Swift, as well as a custom implementation for SwiftUI.

<p align="center">
	<img src="https://github.com/Forethought-Technologies/solve-ios/blob/main/demo.gif" width="296" height="640">
</p>

## Installation

### Swift Package Manager

1. Swift Package Manager is included with Xcode. To use Forethought with your iOS application, simply open your Xcode project and select **File > Add Packages**.

1. Enter the Forethought iOS GitHub repo URL (`https://github.com/Forethought-Technologies/solve-ios`)

1. Tap Add Package. Follow the remaining prompts and Xcode will automatically download the framework

### Cocoapods

1. Forethought is also available through [CocoaPods](http://cocoapods.org). If you have not yet installed Cocoapods, follow their guide to install and create a Podfile [here](https://guides.cocoapods.org/using/getting-started.html).  

1. In your Podfile, add the following line:
   ```ruby
   pod 'Forethought'
   ```
1. Run the following command:
   ```
   $ pod install
   ```
1. Make sure to use the `.xcworkspace` file and *NOT* the `.xcodeproj` from now on.
   
## Usage

1. In your AppDelegate.swift file, add the following lines:
   ```swift
	 ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__")
   ```
1. When you'd like to call the Forethought SDK, add the following:
   ```swift
	 //At the top of your file
   import 'Forethought'
	 
	 //Inside of your class
   @IBAction func contactSupportTapped() {
       ForethoughtSDK.show()
   }
   ```
1. Replace `__YOUR_KEY_HERE__` with your API key you received from Forethought


## Optional Additions

### Custom Data and Config Parameters

You can send custom parameters that you define directly with Forethought like this:
   ```swift
	 ForethoughtSDK.configParameters = ["exampleConfigKey": "exampleConfigValue"]
   ForethoughtSDK.dataParameters = ["language":"EN", "tracking-email":"test@ft.ai"]
   ```

### Use of a Navigation Controller Directly

You can also attach the Forethought SDK directly onto your navigation stack, like this:
   ```swift
   @IBAction func contactSupportTapped() {
       ForethoughtSDK.show(fromNavigationController: self.navigationController)
   }
   ```
 
### Plugins

To attach Forethought to another chat provider, such as Zendesk or Kustomer, please check out our [plugin documentation](Plugins/Plugins.md).
 
### Custom Handoff Methods

If you'd like to handoff Forethought chat to another provider, you can do so by implementing the following:

1. Set a delegate to your Forethought SDK. Do this before presenting the screen:
   ```swift
   ForethoughtSDK.delegate = self
   ```
1. Make sure that the object that you set conforms to the ForethoughtDelegate protocol
   ```swift
   class ViewController: UIViewController, ForethoughtDelegate {
   ```
   
1. Have your object conform to ForethoughtDelegate by adding a single method
   ```swift
   func startChatRequested(handoffData: ForethoughtHandoffData) {
      print("Chat Requested: \(handoffData)")
   }
   ```
1. Add your custom implementation here. You can inspect and view the handoffData object to access history of the previous chat.

## Documentation

Documentation has been provided as a .doccarchive to enable full documentation directly inside Xcode. To use, simply double-click on Forethought.doccarchive, and Xcode will handle the rest.
