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
   - Package name: `com.programiz.editablepin`
5. Download the `google-services.json` file
6. Place it in `demo/android/app/google-services.json`

## Firebase Test Lab Usage with Flutter Integration Tests

Once you've added the configuration file, you can build and run Flutter integration tests on Firebase Test Lab:

### 1. Install Dependencies
```bash
cd demo
flutter pub get
```

### 2. Run Tests Locally (Optional)
```bash
flutter test integration_test/app_test.dart
```

### 3. Build APKs for Firebase Test Lab
```bash
# Build the app APK
flutter build apk

# Build the instrumentation test APK
pushd android
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=$(pwd)/../integration_test/app_test.dart
popd
```

### 4. Run on Firebase Test Lab
```bash
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --device model=Pixel2,version=28,locale=en,orientation=portrait
```

## Flutter Integration Tests

The Flutter integration tests are located at:
```
demo/integration_test/app_test.dart
```

These tests verify:
- App launches successfully and displays main button
- Navigation to PIN editor works
- PIN editor displays 6 input fields
- Can input values in PIN fields
- Can navigate back from PIN editor

All tests use Flutter's `integration_test` package and run the actual Flutter app, providing comprehensive end-to-end testing.
