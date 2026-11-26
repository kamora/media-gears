# media-gears

Video and audio playback for Flutter desktop apps on macOS, Windows and Linux, built on
[mpv](https://mpv.io) and [FFmpeg](https://ffmpeg.org).

media-gears is a desktop-only fork of [media_kit](https://github.com/media-kit/media-kit) by Hitesh Kumar Saini and
its contributors. Its aims:

- one FFmpeg, built by us, shared by playback and by apps that decode video themselves;
- current mpv and FFmpeg releases, built under the LGPL;
- a smaller, desktop-only code base.

## Status

Early development; nothing is published on pub.dev yet.

| Platform | State |
| --- | --- |
| macOS | Builds and plays video, with our own mpv 0.42.0 and FFmpeg 9.1 (LGPLv3), built in [`libs/macos`](libs/macos). |
| Windows | Restructured, not compiled yet. |
| Linux | Restructured, not compiled yet; uses the system's libmpv. |

## Packages

| Package | Contents |
| --- | --- |
| [`media_gears`](packages/media_gears) | The Dart API: `Player`, `Media`, `Video`, `VideoController` and the video controls. |
| [`media_gears_macos`](packages/media_gears_macos) | mpv and FFmpeg for macOS, and the native video output. |
| [`media_gears_windows`](packages/media_gears_windows) | mpv and FFmpeg for Windows, and the native video output. |
| [`media_gears_linux`](packages/media_gears_linux) | The native video output for Linux. |

Apps depend on `media_gears` only; it brings in the package for each platform.

## License

MIT, as media_kit: see [LICENSE](LICENSE). mpv and FFmpeg are distributed under the LGPL.
