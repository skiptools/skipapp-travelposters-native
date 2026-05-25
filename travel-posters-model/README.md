# TravelPostersModel

This is a [Skip](https://skip.dev) Swift/Kotlin library project containing the following modules:

TravelPostersModel

## Building

This project is a Swift Package Manager module that uses the
[Skip](https://skip.dev) plugin to build the package for both iOS and Android.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.
