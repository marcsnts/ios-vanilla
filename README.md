# ios-vanilla
A vanilla flavour version of basic Flybits iOS application for V3

This is an as-simple-as-you-get demostration of the Flybits V3 platform. Here you will learn how our Context, Content and Push SDKs are implemented in an application and learn how to leverage our SDKs and provide contextually relevant content to your users.

Our SDK is supported on iOS version 8 and up!

## Documentation

Please visit our [developer portal](https://devportal.flybits.com)

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate the Flybits SDK into your Xcode project, one option is to use CocoaPod! To do so, specify it in your Podfile:

```ruby
use_frameworks!

pod 'FlybitsKernelSDK'
pod 'FlybitsContextSDK'
pod 'FlybitsPushSDK'
```

### Code Implementation

First import the relevant SDKs into your project:

```swift
import FlybitsKernelSDK
import FlybitsContextSDK
import FlybitsPushSDK
```

## Implementation

### Logging in with Single Sign-On

For your user-login logic, use our `connect(completion:)` API

```swift
let manager = FlybitsManager()
let flybitsManager = FlybitsManager(projectID: projectID, idProvider: flybitsIDP, scopes: scopes)
let scopes: [FlybitsScope] = [KernelScope(), ContextScope(timeToUploadContext: 1, timeUnit: Utilities.TimeUnit.minutes), PushScope()]

let connectRequest = flybitsManager.connect { user, error in
    guard let user = user, error == nil else {
        print("Failed to connect")
        return
    }
    print("Welcome, \(user.firstname!)")
    // Logged in
}
```

Or if a user has already signed in, avoid asking them for their credentials a second time by using the `isConnected(scopes:completion:)` API

```swift
let isConnectedRequest = FlybitsManager.isConnected(scopes: scopes) { isConnected, user, error in
    guard error == nil else {
        print(error!.localizedDescription)
    }
    guard isConnected, let user = user else {
        // Not logged in
        return
    }
    // Logged in
}
```

### Uploading Context

```swift
let contextPlugin = BankingDataContextPlugin(accountBalance: 50, segmentation: "Student", creditCard: "VISA")
_ = try? ContextManager.shared.register(self.contextPlugin!)

// ... Potentially mutate context plugin data here ...

let contextData = contextPlugin.toDictionary()

// Upload any context data you want to update here by passing it in an array
let contextDataRequest = ContextDataRequest.sendData([contextData]) { (error) -> () in
    guard error == nil else {
        // Error sending context data
        return
    }
    // Successfully uploaded context data
}.execute()
```

### Getting Content

```swift
let contentDataRequest = Content.getAllRelevant(with: templateIDsAndClassModelsDictionary, pager: pager) { pagedContent, error in
    guard let pagedContent = pagedContent, error == nil else {
        // Returned without any relevant content
        return
    }
    // Valid content
}
```

### Push

Implementation description will be added soon...
