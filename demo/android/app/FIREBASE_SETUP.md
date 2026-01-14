# Firebase Setup Instructions

## Required Files

To complete the Firebase integration, you need to add your Firebase configuration file:

### Android
Place your `google-services.json` file in this directory:
```
demo/android/app/google-services.json
```

## How to Get the Configuration File

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **editable-pin**
3. Go to Project Settings (gear icon)
4. Under "Your apps", select your Android app (or add one if needed)
   - Package name: `com.example.demo`
5. Download the `google-services.json` file
6. Place it in `demo/android/app/google-services.json`

## Firebase Test Lab Usage

Once you've added the configuration file, you can build and run tests on Firebase Test Lab:

### Build the APKs
```bash
cd demo
flutter build apk
flutter build apk --debug  # For instrumentation tests
```

### Run on Firebase Test Lab
```bash
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --device model=Pixel2,version=28,locale=en,orientation=portrait
```

## Instrumentation Tests

The basic instrumentation test is located at:
```
demo/android/app/src/androidTest/java/com/example/demo/MainActivityTest.java
```

This test verifies:
- App launches successfully
- Main button is displayed
- Navigation to PIN editor works

You can run the tests locally with:
```bash
cd demo
flutter drive --target=test_driver/app.dart
```

Or build the test APK and run on Firebase Test Lab as shown above.
