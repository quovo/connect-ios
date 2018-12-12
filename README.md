# Quovo Connect - iOS SDK

## Latest Release

### [v0.6.8](https://github.com/quovo/connect-ios/releases/tag/v0.6.8)
* Added custom timeout
* Added ability to statically close
* Added embeddable UIView version
* Fixed jarring keyboard issue
* Fixed various bugs

## Installation

You can install the Quovo Connect SDK either by using Cocoapods or by installing the framework manually.

### Using CocoaPods (**Recommended**)
If needed install and setup cocoapods: https://guides.cocoapods.org/using/using-cocoapods

1. Add connect-ios to your project by adding the line `pod 'QuovoConnect'` to your `Podfile`.
2. Run `pod install`
3. Open the xcworkspace

### Using Carthage    
If needed install and setup carthage: https://github.com/Carthage/Carthage#quick-start    

1. Add connect-ios to your project by adding the line `binary "https://raw.githubusercontent.com/quovo/connect-ios/master/QuovoConnectSDK.json"` to your `Cartfile`.
2. Run `carthage update`    
3. If carthage was successful, you should see the framework in the folder Carthage/Build/iOS    
4. Drag the QuovoConnectSDK.framework into your project (Make sure "Copy Items If Needed" is selected)    
5. Highlight your project in the 'Project Navigator'.    
6. Select the 'Build Phases' tab    
7. Click the + button at the top left corner of the Build Phases window and select "New Run Script Phase"    
8. Open the new 'Run Script' expander.    
9. Enter this line into the script box:`/usr/local/bin/carthage copy-frameworks`    
10. Click the + button under “Input Files", and enter: <br>    
`$(SRCROOT)/Carthage/Build/iOS/QuovoConnectSDK.framework`    
11. Click the + button under “Output Files", and enter: `$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/QuovoConnectSDK.framework`    
(note: Make sure to commit your Cartfile.resolved file)    
##### Optionally to warn about outdated dependencies    
1. Click the + button at the top left corner of the Build Phases window and select "New Run Script Phase"    
2. Open the new 'Run Script' expander.    
3. Enter this line into the script box:`/usr/local/bin/carthage outdated --xcode-warnings`

### Manual Installation

1. Download or clone the framework from https://github.com/quovo/connect-ios
2. Open your project's General settings page. Drag QuovoConnectSDK.framework in to the "Embedded Binaries" section. Make sure `Copy items if needed` is selected.
3. Click the + button at the top left corner of the Build Phases window and select "New Run Script Phase" (note: this should be below the 'Embed Frameworks' Phase)
4. Open the new 'Run Script' expander.
5. Enter this line into the script box:<br>
`/bin/sh $BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/QuovoConnectSDK.framework/cleanForAppStore.sh`<br>
This script is required to work around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) 


## Initialize the SDK

```SWIFT
import QuovoConnectSDK
let quovoConnect = QuovoConnectSDK()
```
A good place to initialize the SDK is upon app launch or in the launch method of a view controller.

## Optionally specifiy a parent ViewController

```SWIFT
quovoConnect.parentViewController = UIApplication.shared.keyWindow!.rootViewController
```
This allows you to control which ViewController the QuovoSDK UI will present on

## Create a Completion Handler

```SWIFT
func complete(callback: String, response: NSDictionary) {
// ...
}

quovoConnect.completionHandler = complete
```
The completion handler will allow your app to listen for events that will be fired by the QuovoConnectSDK.  The handler has 2 parameters: a "callback" method name and an optional "response" payload. The "callback" string will be one of the following:

* open
* load
* close
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
"user": 1123,
],
"timeStamp": 1496879583157,
]
```

"Sync" event fired
```swift
[
"connection": [
"id": 2135634,
"institution": 34,
"user": 1123,
],
"sync": [
"authenticated": false,
"status": "questions",
],
"timeStamp": 1496879583157,
]
```

The other callbacks will yield an empty response. For more information on these events, please see:

(https://api.quovo.com/docs/connect/#custom-integrations)

## Create an Error Handler

```SWIFT
func error(errorType: String, errorCode: Int, errorMessage: String) {
// ...
}

quovoConnect.errorHandler = error
```
The error handler will allow your app to listen for errors that have been fired by the QuovoConnectSDK.  The handler has 3 parameters: an "errorType" name, an "errorCode" identifier number and an "errorMessage" string description of the error. The "errorType" string will be one of the following:

* general
* http

In the case of "http" the errorCode field will be an http code, such as 404. In the case of "general" the errorCode field could be an iOS specific code such as an CFNetworkError or a Quovo specific code
List of CFNetworkErrors (https://developer.apple.com/documentation/cfnetwork/cfnetworkerrors) 
The Quovo specific codes include:

* QUOVOERROR_CODE_MISSING_TOKEN:  1

## Launch the SDK

Launching the QuovoConnectSDK will instantiate a WebView experience that allows users to sync and manage their accounts. The minimum required parameter for launching the WebView is an Iframe Token.  This token must be generated via the API and will expire after its first use. 

```swift
quovoConnect.launch(token: "IFRAME TOKEN HERE")
```


This WebView experience can also be created as a View, which can be embedded directly into your application. Note: This view has no Layout Constraints so you will need to add your own.

```swift
let quovoView:UIView = quovoConnect.generateView(token: "IFRAME TOKEN HERE")
```

## Close the SDK

The QuovoConnectSDK can be closed statically by using the QuovoConnectSDK class. This allows the SDK to be closed from the parent ViewController as well as a push notification or other external message.

```swift
QuovoConnectSDK.close()
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

The following is a list of the optional parameters that can be supplied to the launch method:

| Field                | Type          | Default       | Description |
| -------------------- | ------------- | ------------- | ----------- |
| topInstitutions      | string        | 'all'         | Choose what type of institutions, if any, will be displayed in the Top Institutions portion of the institution select screen. Possible values are `banks`, `brokerages`, `all`, or `none`. |
| enableAuthDeposits   | integer (bit) | 0             | If on, the [Auth Deposits](https://api.quovo.com/docs/auth/#auth_deposits) workflow will be enabled within Connect. This lets end users verify their bank accounts on any institution not covered by instant account verification. Note: This workflow is _not_ available by default. [Contact us](mailto:support@quovo.com) if you would like access to Auth Deposits within Connect. |
| singleSync           | integer (bit) | 0             | If on, the "Connect Another Account" button will be hidden. This button appears once an Account has been successfully synced to prompt the User to add any additional Accounts they may have. |
| searchTest           | integer (bit) | 0             | If on, Quovo test institutions will be searchable within Connect. |
| openInstitution      | integer       |               | [See Preselect an Institution](#preselect-an-institution) |
| openConnection       | integer       |               | [See Update or Resolve Issues on an Existing Connection](#update-or-resolve-issues-on-an-existing-connection) |

## Preselect an Institution

You may want to direct users to add Accounts onto specific institutions. With Connect, you can preselect an institution for users and bypass the search page entirely.

Pass the desired Quovo Brokerage ID as the value.

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
// Connect will bypass the search page and open directly to the page to
// add a "Fidelity NetBenefits" Account (which has a Brokerage ID of 23).
"openInstitution": 23,
]
)
```

## Update or Resolve Issues on an Existing Connection

You may want users to update or resolve issues on existing connections. They may need to supply additional MFA answers or update recently changed login credentials. With Connect, you can simply pass an Account ID to direct users to fix these issues, allowing their Accounts to continue syncing. Connections with a "login" status will be taken to a screen where users can update their credentials, while connections with a "questions" status will be taken to a screen where users are prompted to answer additional MFA questions.

If both `openConnection` and `openInstitution` arguments are supplied to `launch`, the `openConnection` workflow will take priority.

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
// Account 813981 has a status of "questions", so Connect will open to a
// page where the user can answer any outstanding MFA questions and resync
// the Account accordingly.
"openConnection": 813981,
]
)
```

## Custom Navbar

You also have the option to customize the navbar  for the QuovoConnect WebView. The three aspects of the navbar that can be customized are the translucency, the color, and the text. 

The `isTranslucent` parameter will take precedence over the `backGroundColor` parameter. 

```swift
 quovoConnect.customizeNavigationBarApperance(
    isTranslucent: true,
    //The paramater isTranslucent is a boolean that can make the navigation bar  transparent.
    backGroundColor: UIColor.white, 
    //The backGroundColor parameter allows you to choose the color of the navbar.
    customTitle: "Quovo Connect")
    //The customTitle parameter allows you to choose the text displayed in the navbar. Passing an empty string will result in no text being displayed.
```

## Custom Timeout

By default the Quovo Connect WebView will timeout after 30 seconds of attempting to connect. There is an option to customize the timeout length in seconds by calling `setTimeoutLength`, which takes a `TimeInterval` parameter (aka a double). When a timeout occurs an error will be sent to the ErrorHandler and the WebView will display a simple page stating that the connection timed out.

```swift
    quovoConnect.setTimeoutLength(seconds:5)
```

## Using the Test Project

The test project included with the SDK uses a configuration plist file to generate its user token. The file is git-ignored but should be added to your copy of the test project. The file should be named "configuration.plist" and should contain a String field named "apiToken" and a Number field name "userId".
