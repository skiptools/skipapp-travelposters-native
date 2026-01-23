# TravelPostersNative

This is a demonstration of using a shared [Skip Fuse](https://skip.dev) dual-platform model library in native Swift to power both an iOS and an Android app.

For more information on this project, see the blog post
[Native Swift on Android, Part 3: Sharing a Swift Model Layer](https://skip.dev/blog/shared-swift-model/).

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

For example, to re-build and re-launch the app after making changes to the Swift code, you might run:

```shell
skip export --project travel-posters-model -d Android/lib/debug/ --debug
gradle -p Android installDebug
adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n tools.skip.travelposters/tools.skip.travelposters.MainActivity
```

## Building & Running

Use Xcode to build and run the iOS app and the shared `travel-posters-model` package.

Use Android Studio to build and run the Android app. Before building the Android app the first time, you must follow the instructions above to donate the native model build. Then use “Sync Project with Gradle Files” in Android Studio to sync the donated libraries. Do this every time you update the library versions.

## Deployment Notes

Note the following declaration in `Android/app/build.gradle.kts`:

```kotlinscript
android {
    packaging {
        jniLibs {
            // doNotStrip is needed to prevent errors like: java.lang.UnsatisfiedLinkError: dlopen failed: empty/missing DT_HASH/DT_GNU_HASH in "/data/app/…/base.apk!/lib/arm64-v8a/libdispatch.so" (new hash type from the future?) (see: https://github.com/finagolfin/swift-android-sdk/issues/67)
            keepDebugSymbols.add("**/*.so")
        }
    }
}
```

This is needed to prevent a known issue with some compiled Swift libraries.


