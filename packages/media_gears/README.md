# media_gears

Video and audio playback for Flutter desktop apps on macOS, Windows and Linux, built on [mpv](https://mpv.io) and
[FFmpeg](https://ffmpeg.org).

media_gears is a desktop-only fork of [media_kit](https://github.com/media-kit/media-kit) by Hitesh Kumar Saini and its
contributors. It is in early development: the API may still change, and nothing is published on pub.dev yet.

## Platforms

| Platform | State |
| --- | --- |
| macOS 12 or later | Builds and plays video, with mpv 0.42.0 and FFmpeg 9.1 built by media_gears. |
| Windows | Not compiled yet. |
| Linux | Not compiled yet; it will use the system's libmpv (`libmpv-dev` on Debian and Ubuntu). |

## Installation

Until media_gears is on pub.dev, depend on it from git; the platform packages come from the same repository:

```yaml
dependencies:
  media_gears:
    git:
      url: https://github.com/kamora/media-gears.git
      path: packages/media_gears

dependency_overrides:
  media_gears_macos:
    git:
      url: https://github.com/kamora/media-gears.git
      path: packages/media_gears_macos
  media_gears_windows:
    git:
      url: https://github.com/kamora/media-gears.git
      path: packages/media_gears_windows
  media_gears_linux:
    git:
      url: https://github.com/kamora/media-gears.git
      path: packages/media_gears_linux
```

An app depends on `media_gears` only; it brings in the package for each platform.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:media_gears/media_gears.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaGears.ensureInitialized();
  runApp(const MaterialApp(home: Screen()));
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media('file:///Users/me/Movies/sample.mp4'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Video(controller: controller));
  }
}
```

### Player

`Player` plays a `Media` (a file path, or a `file://`, `http(s)://` or `asset:///` URI) or a `Playlist` of them. It
offers:

- control: `open`, `play`, `pause`, `playOrPause`, `stop`, `seek`, `next`, `previous`, `jump`, `add`, `remove`,
  `move`, `setVolume`, `setRate`, `setPitch`, `setShuffle`, `setPlaylistMode`, `setAudioDevice`, `setVideoTrack`,
  `setAudioTrack`, `setSubtitleTrack`, `screenshot` and `dispose`;
- state: `player.state` holds the current values, and `player.stream` has a stream for each, such as `playing`,
  `position`, `duration`, `buffering`, `playlist`, `tracks`, `videoParams`, `error` and `log`;
- mpv itself: `setProperty`, `getProperty`, `observeProperty`, `unobserveProperty` and `command`.

`PlayerConfiguration` sets a player up once: the log level, whether libass renders subtitles, the buffer size, the
protocols allowed, and mpv's video output (`vo`) for a player without a `VideoController`.

### Video

`VideoController` renders a player's video into a Flutter texture, and the `Video` widget shows it, with
`DesktopControls` by default. `NoControls` shows the video alone, and any builder that takes the video's state can
draw other controls. `VideoConfiguration` can fix the output to a size smaller than the video, which costs less, or
turn hardware rendering off.

The app in `example/` plays the file given as its first argument.

## License

MIT, as media_kit: see [LICENSE](LICENSE). mpv and FFmpeg are distributed under the LGPL.
