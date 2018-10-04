# Quovo Connect - iOS SDK
## Installation

You can install the Quovo Connect SDK either by using Cocoapods or by installing the framework manually.

### Using CocoaPods (**Recommended**)
If needed install and setup cocoapods: https://guides.cocoapods.org/using/using-cocoapods

1. Add connect-ios to your project by adding the line `pod 'QuovoConnect'` to your `Podfile`.
2. Run `pod install`
3. Open the xcworkspace

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

## Launch the SDK

Launching the QuovoConnectSDK will instantiate a WebView experience that allows users to sync and manage their accounts. The minimum required parameter for launching the WebView is an Iframe Token.  This token must be generated via the API and will expire after its first use.

```swift
quovoConnect.launch(token: "IFRAME TOKEN HERE")
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


