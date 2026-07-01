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

    //Solve Web Call
    ForethoughtSDK.start(apiKey: "__YOUR_KEY_HERE__", isWebCall: true)
    ```
1. Open the Forethought widget:
    ```swift
    import 'Forethought'

    ForethoughtSDK.show()
    ```

## Other ways to open widget

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
ForethoughtSDK.dataParameters = ["language": "EN", "user-email": "test@ft.ai", "workflow-context-variable": "value"]
```

### Widget Configuration Parameters

Current [configuration parameters](https://support.forethought.ai/hc/en-us/articles/1500002917301-Installation-Guide-for-Solve-Widget#:~:text=Additional%20Attributes) are all the `config-ft` prefixed parameters under Additional Attributes. (Note: you do not need to prefix with `config-ft`)

```swift
ForethoughtSDK.configParameters = ["theme-color": "#7b33fb"]
```

### Additional Parameters

Pass in non `data-ft` / `config-ft` using ForethoughtSDK.additionalParameters. A comprehensive list of parameters can be found [here.](https://support.forethought.ai/hc/en-us/articles/1500002917301-Installation-Guide-for-Solve-Widget#:~:text=Additional%20Attributes)

```swift
ForethoughtSDK.additionalParameters = ["initial-intent-id": "79fc012c-cce3-4574-9b75-7b272310d854"]
```

### Other customizations

#### ForethoughtSDK.modalPresentationStyle

Default style is `UIModalPresentationStyle.popover` (Note this does not apply when using `fromNavigationController`).

```swift
ForethoughtSDK.modalPresentationStyle = UIModalPresentationStyle.fullScreen
```

### Forethought Delegate

Forethought delegate is used to respond to events during the widget conversation that may need additional implementation.
All methods in the `ForethoughtDelegate` are optional as well.

```swift
@objc public protocol ForethoughtDelegate: AnyObject {
    // Customer requested a handoff. Implement your own handoff from Forethought to another SDK (e.g. Zendesk or Salesforce)
    @objc optional func startChatRequested(handoffData: ForethoughtHandoffData)
    // Customer clicked the close widget button. Make sure to call ForethoughtSDK.hide if you choose to implement this
    @objc optional func widgetClosed()
    // Widget experienced an error causing it not be able to render
    @objc optional func widgetError(errorData: ForethoughtErrorData)
}
```

To setup the delegate

1. Set a delegate to the Forethought SDK. Do this before presenting the screen:
    ```swift
    ForethoughtSDK.delegate = self
   ```
1. Make sure the object conforms to the ForethoughtDelegate protocol
    ```swift
    class ViewController: UIViewController, ForethoughtDelegate {
    ```
1. Add any of the optional delegate methods you want to handle

#### startChatRequested Example

```swift
func startChatRequested(handoffData: ForethoughtHandoffData) {
    print("Chat Requested: \(handoffData)")

    // close forethought widget
    ForethoughtSDK.hide(animated: false) {
        // start a Kustomer chat
        Kustomer.startNewConversation(initialMessage: KUSInitialMessage(body: handoffData.question, direction: .user))
        ForethoughtSDK.sendHandoffResponse(success: true)
    }

    // if handoff was unsuccessful
    ForethoughtSDK.show()
    ForethoughtSDK.sendHandoffResponse(success: false)
}
```

#### widgetClosed Example

```swift
func widgetClosed() {
    // add any additional logic here

    ForethoughtSDK.hide(animated: true) {
        print("forethought - widgetClosed")
    }
}
```

#### widgetError Example

```swift
func widgetError(errorData: ForethoughtErrorData) {
    // add any additional logic here

    ForethoughtSDK.hide(animated: true) {
        print("forethought - \(errorData.error)")
    }
}
```

### Other APIs

#### Trigger Event

Trigger events are configured via the Forethought Dashboard and are emitted by the widget during a conversation. Implement the `triggerEventReceived` delegate method to respond to them, then call `ForethoughtSDK.sendTriggerEventResponse` with the payload the widget expects.

```swift
// ForethoughtDelegate
@objc optional func triggerEventReceived(triggerEventData: ForethoughtTriggerEventData)
```

`ForethoughtTriggerEventData` exposes the following properties:

```swift
public class ForethoughtTriggerEventData: NSObject {
    public let name: String?                          // The name of the trigger event
    public let expectedContextVariables: [String]     // Context variable keys the widget expects back
    public let additionalContext: [String: Any]?      // Any additional context sent with the event
}
```

Example:

```swift
func triggerEventReceived(triggerEventData: ForethoughtTriggerEventData) {
    print("Trigger event received: \(triggerEventData.name ?? "")")

    // Build the payload using the expected context variables
    let payload: [String: Any] = ["user-tier": "gold"]

    // Respond to the trigger event. Use the event name as the identifier.
    ForethoughtSDK.sendTriggerEventResponse(identifier: triggerEventData.name ?? "", payload: payload)
}
```

#### clearLocalData

Clears any locally cached data (e.g. conversation state) held by the SDK.

```swift
ForethoughtSDK.clearLocalData()
```

#### launchQuery

Opens the widget with a query so the conversation starts from a specific question.

```swift
ForethoughtSDK.launchQuery("How do I reset my password?")
```

#### updateConversationContext

Updates the context of the current conversation with additional key/value pairs.

```swift
ForethoughtSDK.updateConversationContext(["<cv_id>": "new cv value"])
```

#### updateConfigParams

Updates the widget configuration parameters at runtime (the same `config-ft` parameters described under [Widget Configuration Parameters](#widget-configuration-parameters)).

```swift
ForethoughtSDK.updateConfigParams(["theme-color": "#7b33fb"])
```

#### sendMessage

Sends a message into the current conversation on the user's behalf.

```swift
ForethoughtSDK.sendMessage("I need help with my order")
```

### Plugins

**⛔️ Plugins are deprecated in starting in version 2.0.0 ⛔️**

## Documentation

Documentation has been provided as a .doccarchive to enable full documentation directly inside Xcode. To use, simply double-click on Forethought.doccarchive, and Xcode will handle the rest.
