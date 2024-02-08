# Forethought - Solve iOS SDK

This repository contains the framework and instructions for the Forethought iOS SDK.

A valid API key is needed in order to use the Forethought Solve SDK. In additon to the documentation below, sample apps have been written in Objective-C & Swift, as well as a SwiftUI implementation

<p align="center">
	<img src="https://github.com/Forethought-Technologies/solve-ios/blob/main/demo.gif" width="296" height="640">
</p>

## Installation

### Swift Package Manager

1. In Xcode, **File > Add Packages**.

1. Enter the Forethought iOS GitHub repo URL (`https://github.com/Forethought-Technologies/solve-ios`)

1. Tap **Add Package**. Follow the remaining prompts and Xcode will automatically download the framework

### Cocoapods

1. Forethought is also available through [CocoaPods](http://cocoapods.org).

1. In the `Podfile`, add the following line:
   ```ruby
   pod 'Forethought'
   ```
1. Run the following command:
   ```
   $ pod install
   ```
1. Make sure to use the `.xcworkspace` file and **NOT** the `.xcodeproj` from now on.

## Basic Usage

1. In `AppDelegate.swift` file, replace `__YOUR_KEY_HERE__` with a valid Forethought API key:
    ```swift
    ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__")
    ```
1. Open the Forethought widget:
    ```swift
    import 'Forethought'

    ForethoughtSDK.show()
    ```

## Other ways to open

### SwiftUI View

Returns a SwiftUI view
```swift
ForethoughtSDK.forethoughtView
```

### Use of a Navigation Controller Directly

Attach the Forethought SDK directly onto a navigation stack:
   ```swift
   @IBAction func contactSupportTapped() {
       ForethoughtSDK.show(fromNavigationController: self.navigationController)
   }
   ```

## Optional Additions

### Workflow Context Variables

Pass in Workflow Context Variables that have been defined via the Forethought Dashboard. (Note: you do not need to prefix with `data-ft`)

```swift
ForethoughtSDK.dataParameters = ["language":"EN", "user-email": "test@ft.ai", "workflow-context-variable": "value"]
```

### Widget Configuration Parameters

Current [configuration parameters](https://support.forethought.ai/hc/en-us/articles/1500002917301-Installation-Guide-for-Solve-Widget#:~:text=Additional%20Attributes) are all the `config-ft` prefixed parameters under Additional Attributes. (Note: you do not need to prefix with `config-ft`)

```swift
ForethoughtSDK.configParameters = ["theme-color": "#7b33fb"]
```

### Handoff Methods

To handoff customers from Forethought to an Agent Chat Provider like Kustomer:

1. Set a delegate to the Forethought SDK. Do this before presenting the screen:
    ```swift
    ForethoughtSDK.delegate = self
   ```
1. Make sure the object conforms to the ForethoughtDelegate protocol
    ```swift
    class ViewController: UIViewController, ForethoughtDelegate {
    ```
1. Conform to ForethoughtDelegate by adding the following method
    ```swift
    func startChatRequested(handoffData: ForethoughtHandoffData) {}
    ```
1. Add handoff implementation here. For example.
    ```swift
    Kustomer.show(...)
    Kustomer.startNewConversation(...)
    ```
1. When the handoff is complete, `sendHandoffResponse` will continue the Forethought conversation and update the conversation context as successfully passed off to an Agent Chat Provider or not.
    ```swift
    ForethoughtSDK.sendHandoffResponse(success: true)
    ```

#### Handoff Example

```swift
func startChatRequested(handoffData: ForethoughtHandoffData) {
    print("Chat Requested: \(handoffData)")

    // close forethought widget
    ForethoughtSDK.hide(animated: false)

    // start a Kustomer chat
    Kustomer.startNewConversation(initialMessage: KUSInitialMessage(body: handoffData.question, direction: .user))

    // if handoff was successful
    ForethoughtSDK.sendHandoffResponse(success: true)

    // if handoff was unsuccessful
    ForethoughtSDK.show()
    ForethoughtSDK.sendHandoffResponse(success: false)
}
```

### widgetClosed delegate

Called when the customer presses the close widget icon. Make sure to call `ForethoughtSDK.hide` if you choose to implement this.

```swift
func widgetClosed() {
    // do something
    // call hide to dismiss the widget
    ForethoughtSDK.hide(animated: true) {
        // do something on completion
    }
}
```

### Plugins

**⛔️ Plugins are deprecated in starting in version 2.0.0 ⛔️**

## Documentation

Documentation has been provided as a .doccarchive to enable full documentation directly inside Xcode. To use, simply double-click on Forethought.doccarchive, and Xcode will handle the rest.
