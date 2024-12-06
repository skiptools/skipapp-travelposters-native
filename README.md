# TravelPostersNative

This is a demonstration of using a shared [Skip](https://skip.tools) dual-platform model library in native Swift to power both an iOS and an Android app.

## Workflow

Iterate on both the `travel-posters-model` shared model package and the iOS app by opening the `TravelPostersNative.xcworkspace` Xcode workspace.

Iterate on the Android app by opening the `Android/settings.gradle.kts` file in Android Studio.

To donate the latest `travel-posters-model` shared model code to the Android app's debug target and then build the app:

```shell
$ skip export --project travel-posters-model -d Android/lib/debug/ --debug
$ gradle -p Android assembleDebug
```

Similarly, for the release build, you would run:

```shell
$ skip export --project travel-posters-model -d Android/lib/release/ --release
$ gradle -p Android assembleRelease
```

There are many ways to automate this process, from simple scripting to git submodules to publishing the Android `travel-posters-model` output to a local Maven repository. Use whatever system fits your team's workflow best.

## Building & Running

Use Xcode to build and run the iOS app and the shared `travel-posters-model` package.

Use Android Studio to build and run the Android app. Before building the Android app the first time, you must follow the instructions above to donate the native model build. Then use “Sync Project with Gradle Files” in Android Studio to sync the donated libraries. Do this every time you update the library versions.
