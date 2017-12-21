# Quovo Connect - iOS SDK
## Installation

### Manual Installation

  1. Open your project in Xcode.
  2. Drag the QuovoConnectSDK.framework into your project
  3. Highlight your project in the 'Project Navigator'.
  4. Select the 'Build Phases' tab
  5. Open the 'Embed Frameworks' expander.
  6. Click the + button and select QuovoConnectSDK.framework
  7. Make sure "Code Sign on Copy" is enabled

### Using CocoaPods

  1. Add connect-ios to your project by adding the line `pod QuovoConnect` to your `podfile`.
  2. Run `pod install`
  3. Add the following script to Archive -> Pre-actions in your application's scheme
  ```
  FRAMEWORK_NAME="QuovoConnect"
  cd ${SRCROOT}/Pods/${FRAMEWORK_NAME}/
  if [ -f "${FRAMEWORK_NAME}.zip" ]
  then
      unzip -o ${FRAMEWORK_NAME}.zip
  else
      zip -r ${FRAMEWORK_NAME}.zip ./${FRAMEWORK_NAME}.framework
  fi
  lipo ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} -thin armv7 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7
  lipo ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME} -thin arm64 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64
  rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}
  lipo -create ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7 ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64 -output ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}
  rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}armv7
  rm -rf ${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}arm64
  rm -rf ${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/i386*
  rm -rf ${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/x86*
  ```
  4. Add the following script to Archive -> Post-actions
  ```
  FRAMEWORK_NAME="QuovoConnect"
  cd ${SRCROOT}/Pods/${FRAMEWORK_NAME}/
  rm -rf ./${FRAMEWORK_NAME}.framework
  unzip -o ${FRAMEWORK_NAME}.zip
  rm -rf ${FRAMEWORK_NAME}.zip
  ```

  **Note:** Steps 3 and 4 are required in order to be able to test connect-ios using the Xcode simulators and still be able to publish via the App Store. If you're only interested in using connect-ios for development, you can skip those steps until you're ready to publish.

## Initialize the SDK

```SWIFT
import QuovoConnectSDK
let quovoConnect = QuovoConnectSDK()
```
A good place to initialize the SDK is upon app launch or in the launch method of a view controller.

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

## Custom Navbar Title

You also have the option to customize the navbar title for the QuovoConnect WebView:

```swift
quovoConnect.customTitle = "Connect Your Accounts"
```
