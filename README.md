# Quovo Connect - iOS SDK
## Installation

1. Open your project in Xcode.
2. Drag the QuovoConnectSDK.framework into your project
3. Highlight your project in the 'Project Navigator'.
4. Select the 'Build Phases' tab
5. Open the 'Embed Frameworks' expander.
6. Click the + button and select QuovoConnectSDK.framework
7. Make sure "Code Sign on Copy" is enabled

## Initialize the SDK

```SWIFT
import QuovoConnectSDK
let quovoConnect = QuovoConnectSDK()
```
A good place to initialize the SDK is upon app launch or in the launch method of a view controller.

## Create a Completion Handler

```SWIFT
func complete(callback: String, response: NSDictionary) {
}

quovoConnect.completionHandler = complete
```
The completion handler will allow your app to listen for events that will be fired by the QuovoConnectSDK.  The handler has 2 parameters: a "callback" method name and an optional "response" payload. The "callback" string will be one of the following:

* open
* load
* close
* cancel
* add
* sync

In the case of "add" and "sync" a response payload of type NSDictionary will be returned.

Here are some examples:

"Add" event fired:

```swift
[
"connection": [
"id": 2135634,
"institution": 34,
"user": 1123
],
"timeStamp": 1496879583157
]
```

"Sync" event fired
```swift
[
"connection": [
"id": 2135634,
"institution": 34,
"user": 1123
],
"sync": [
"authenticated": false,
"status": "questions"
],
"timeStamp": 1496879583157
]
```

The other callbacks will yield an empty response. For more information on these events, please see:

(https://api.quovo.com/docs/connect/#scustom-integrations)

## Launch the SDK

Launching the QuovoConnectSDK will instantiate a WebView experience that allows users to sync and manage their accounts. The minimum required parameter for launching the WebView is an Iframe Token.  This token must be generated via the API and will expire after its first use.

```swift
quovoConnect.launch( token:"IFRAME TOKEN HERE" )
```

## Customization

You can optionally pass in a set of parameters that control the appearance and functionality of the WebView experience.  An example of this is:

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
"testInstitutions": 1,
"topInstitutions": "banks",
]
)
```

Documentation for customization options can be found here:

(https://api.quovo.com/docs/connect/#custom-integrations)

Please note that the customization option variable names are camelCased.

Some options, such as preselecting an institution or updating an existing account, are documented as arguments for the js SDK's `open` method. As this SDK doesnt utilize an `open` method and instead uses `launch` to both instantiate and open the widget, you can supply the same parameters to `launch` by prepending the string `open-` to the parameter key and adding them to the `options` list.

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
"testInstitutions": 1,
"topInstitutions": "banks",
"open-institution": 34,
]
)
```

