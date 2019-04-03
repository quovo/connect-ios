# Quovo Connect SDK for iOS

## Latest Release

### [v1.1.6](https://github.com/quovo/connect-ios/releases/tag/v1.1.6)
* Fixed issue compiling with swift 5 (Xcode 10.2)


## Table Of Contents
<!--ts-->
* [Installation](#installation)
* [Using The Test Project](#using-the-test-project)
* [Quovo Connect SDK](#quovo-connect-sdk)
    * [Initialize the SDK](#initialize-the-connect-sdk)
    * [Optionally specify a parent ViewController](#optionally-specify-a-parent-viewcontroller-for-connect)
    * [Create a Completion Handler](#create-a-completion-handler-for-connect)
        * [Connect v1 Callbacks](#connect-v1-callbacks)
        * [Connect v2 Callbacks](#connect-v2-callbacks)
    * [Create an Error Handler](#create-an-error-handler-for-connect)
    * [Launch the SDK](#launch-the-connect-sdk)
    * [Close the SDK](#close-the-connect-sdk)
    * [Customization](#connect-customization)
        * [Custom Navbar](#custom-connect-navbar)
        * [Custom Timeout](#custom-connect-timeout)
        * [Custom Subdomain](#custom-connect-subdomain)
        * [Options for Connect v1](#options-for-connect-v1)
        * [Options for Connect v2](#options-for-connect-v2)
        * [Preselect an Institution](#preselect-an-institution)
        * [Update or Resolve Issues on an Existing Connection](#update-or-resolve-issues-on-an-existing-connection)
<!--te-->

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


## Using the Test Project

The test project included with the SDK uses a configuration plist file to generate its user token. The file is git-ignored but should be added to your copy of the test project. The file should be named "configuration.plist" and should contain a String field named "apiToken" and a Number field name "userId".


## Quovo Connect SDK

### Initialize the Connect SDK

```SWIFT
import QuovoConnectSDK
let quovoConnect = QuovoConnectSDK()
```
A good place to initialize the SDK is upon app launch or in the launch method of a view controller.


### Optionally specify a parent ViewController for Connect

```SWIFT
quovoConnect.parentViewController = UIApplication.shared.keyWindow!.rootViewController
```
This allows you to control which ViewController the QuovoSDK UI will present on


### Create a Completion Handler for Connect

```SWIFT
func complete(callback: String, response: NSDictionary) {
// ...
}

quovoConnect.completionHandler = complete
```
The completion handler will allow your app to listen for events that will be fired by the QuovoConnectSDK.  The handler has 2 parameters: a "callback" method name and an optional "response" payload. 

### Connect v1 Callbacks

The "callback" strings supported by connect v1 are the following:

* open
* load
* close
* add
* sync
* onAuthenticate

In the case of "add", "sync" and "onAuthenticate" a response payload of type NSDictionary will be returned.

### Connect v2 Callbacks

The "callback" strings supported by connect v2 are the following:

* open
* load
* close
* add
* sync
* onAuthenticate
* onAuthAccountSelected

In the case of "add", "sync",  "onAuthenticate" and onAuthAccountSelected a response payload of type NSDictionary will be returned.

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


### Create an Error Handler for Connect

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


### Launch the Connect SDK

Launching the QuovoConnectSDK will instantiate a WebView experience that allows users to sync and manage their accounts. The minimum required parameter for launching the WebView is an Iframe Token.  This token must be generated via the API and will expire after its first use. 

```swift
quovoConnect.launch(token: "IFRAME TOKEN HERE")
```

This WebView experience can also be created as a View, which can be embedded directly into your application. Note: This view has no Layout Constraints so you will need to add your own.

```swift
let quovoView:UIView = quovoConnect.generateView(token: "IFRAME TOKEN HERE")
```


### Close the Connect SDK

The QuovoConnectSDK can be closed statically by using the QuovoConnectSDK class. This allows the SDK to be closed from the parent ViewController as well as a push notification or other external message.

```swift
QuovoConnectSDK.close()
```


### Connect Customization


#### Custom Connect Navbar

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


#### Custom Connect Timeout

By default the Quovo Connect WebView will timeout after 30 seconds of attempting to connect. There is an option to customize the timeout length in seconds by calling `setTimeoutLength`, which takes a `TimeInterval` parameter (aka a double). When a timeout occurs an error will be sent to the ErrorHandler and the WebView will display a simple page stating that the connection timed out. If you do not want to display the timeout page you can catch the error in the ErrorHandler and close the SDK before it appears or timeout before the SDK does.

```swift
quovoConnect.setTimeoutLength(seconds:5)
```


#### Custom Connect Subdomain

By default the Connect SDK will connect to the original Quovo Connect, however there is a way to use Connect v2. By calliing `setSubdomain` (which takes a `String`) you can set a custom subdomain to be used when loading connect. If you want to load Connect v2, you can pass in `connect2`.

```swift
quovoConnect.setSubdomain(subdomain:"connect2")
```

Alternatively, you can also set a custom subdomain from within the launch function. Simply add the `subdomain` parameter after the token or options.

```swift
quovoConnect.launch(token: "IFRAME TOKEN HERE",subdomain:"connect2")
```
Note that if you set the subdomain using both setSubdomain and launch, the launch subdomain will override the set subdomain.


#### Options for Connect v1

You can optionally pass in a set of parameters that control the appearance and functionality of the WebView experience.  An example of this is:

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
"searchTest": 1,
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
| hideTray  | integer (bit) | 0 |   If on, the tray showing notifications will be hidden (Note: Only applies to Connect v2) |
| syncType             | String       |                | Choose what type of connection syncs are performed within Connect. Possible values are `agg`, `auth`, or `both`, which will simultaneously run an agg AND auth sync on new connections. This parameter is optional and will default to agg. More information on integrating account verification with Connect can be found here. (https://api.quovo.com/docs/v3/ui/#auth)


### Options for Connect v2

You can optionally pass in a set of parameters that control the appearance and functionality of the WebView experience.  An example of this is:

```swift
quovoConnect.launch(
token: "IFRAME TOKEN HERE",
options: [
"searchTest": 1,
"topInstitutions": "banks",
]
)
```

The following is a list of the optional parameters that can be supplied to the launch method for Connect2:

| Field                | Type          | Default       | Description |
| -------------------- | ------------- | ------------- | ----------- |
| topInstitutions      | string or array    | 'all'         | Choose what type of institutions, if any, will be displayed in the Top Institutions portion of the institution select screen. Possible values are `banks`, `brokerages`, `all`, or `none`. <br>If you'd like to customize the default institutions you can pass in an array of institution ids like: `[1249,1209,2779,2782]` |
| searchTest           | integer (bit) | 0             | If on, Quovo test institutions will be searchable within Connect. |
| openInstitution      | integer       |               | [See Preselect an Institution](#preselect-an-institution) |
| openConnection       | integer       |               | [See Update or Resolve Issues on an Existing Connection](#update-or-resolve-issues-on-an-existing-connection) |
| hideTray  | integer (bit) | 0 |   If on, the tray showing notifications will be hidden |
| syncType             | String       |                | Choose what type of connection syncs are performed within Connect. Possible values are `agg`, `auth`, `aggBoth` or `authBoth`.  This parameter is optional and will default to agg.  Connect has specific screen flows that are configured for agg vs auth sync types if using  `aggBoth` or `authBoth` you will need to define which is the primary workflow for your users as it will simultaneously run an agg AND auth sync on new connections.  More information on integrating account verification with Connect can be found here. (https://api.quovo.com/docs/v3/ui/#auth)|
| headerText           | string|              | Choose the global header text. This parameter is optional and will default to Connect Accounts.|
| showManualAccounts   | integer (bit)|  0    | Choose whether the “Enter Manually” displays at bottom of landing page & search results. If False, this section will be hidden. This parameter is optional and will default to True.|
| confirmClose         | integer (bit)|  1    | Defaults to `true`, setting to `false` will hide the prompt asking the user to confirm that they’d like to close the Connect Widget will be presented when the "close" icon is clicked.|

<br>
<br>
<br>
On Enter Credentials screen, there is messaging below the password field that can be configured using the fields below:
<br>
<br>
<br>

| Field                | Type          | Default       | Description |
| -------------------- | ------------- | ------------- | ----------- |
| learnMoreIsHidden    | integer (bit) |    0          | Defaults to `false`, setting to `true` will hide the "We use bank-level encryption to keep your data secure. Learn More"|
| learnMoreInfoMessage           | string|           | Configure text for "We use bank-level encryption to keep your data secure. Learn More". This parameter is optional and will default to text above.|
| learnMoreText           | string|              | Configure text for "Learn More". This parameter is optional and will default to text above.|
| learnMoreUrl           | string|              | By default this is set to `false` and when clicking the text "Learn More", you will be re-directed to https://www.quovo.com/infosec/. Configure by entering url into this parameter.|



#### Preselect an Institution

You may want to direct users to add Accounts onto specific institutions. With Connect, you can preselect an institution for users and bypass the search page entirely.

Pass the desired Quovo Instition ID as the value.

```java
HashMap<String, Object> options = new HashMap<>();
// Connect will bypass the search page and open directly to the page to
// add a "Fidelity NetBenefits" Account (which has a Brokerage ID of 23).
options.put("openInstitution", 23);

quovoConnectSdk.launch(userToken, options);
```

#### Update or Resolve Issues on an Existing Connection

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
