# media_gears_macos

The macOS side of [media_gears](https://github.com/kamora/media-gears): mpv 0.42.0 and FFmpeg 9.1 as frameworks built by media_gears (see `libs/macos` in the repository), and the Swift code that renders mpv's video into a Flutter texture.

State: Builds and plays video on macOS 12 or later, with Swift Package Manager or CocoaPods. Swift Package Manager
fetches the frameworks from the release itself (`macos/media_gears_macos/Package.swift`); CocoaPods runs the Makefile.

Apps don't depend on this package directly: they depend on `media_gears`, which brings it in. Derived from media_kit's
macOS packages; MIT, see [LICENSE](LICENSE).
