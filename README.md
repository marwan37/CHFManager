# CHFManager

## Overview

CHFManager is an iOS application built with Swift and SwiftUI. The app is designed to manage various aspects of CHF (Congestive Heart Failure) and aims to provide a seamless user experience.

## Features

- News Feed
- User Authentication
- Data Management

## Technologies Used

- Swift/SwiftUI
- Firebase
- Firestore
- Google Sign-In
- Inspired by Apple's CareKit and ResearchKit frameworks

## Requirements

- iOS 14.0+
- Xcode 12.0+

## Installation

### CocoaPods

Run the following command to install the necessary CocoaPods:

```bash
pod install
```

### Firebase Setup

1. Download the `GoogleService-Info.plist` file from your Firebase Console and add it to your Xcode project.
2. Initialize Firebase in `AppDelegate.swift`:

```swift
import Firebase
...
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    ...
}
```

### Google Sign-In Setup

1. Configure Google Sign-In in `GoogleSignInManager.swift`:

```swift
import GoogleSignIn
...
GIDSignIn.sharedInstance().clientID = "YOUR_CLIENT_ID"
```

## Usage

1. Run `pod install` to install dependencies.
2. Open the `.xcworkspace` file in Xcode.
3. Build and run the project.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT
