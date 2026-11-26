/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

import 'package:media_gears/src/models/video_params.dart';
import 'package:media_gears/src/player/player.dart';

/// {@template video_controller}
///
/// VideoController
/// ---------------
///
/// [VideoController] renders the video of a [Player] into a Flutter texture, which the [Video] widget shows.
///
/// ```dart
/// late final player = Player();
/// late final controller = VideoController(player);
/// ```
///
/// A fixed [VideoConfiguration.width] and [VideoConfiguration.height] make the output smaller than
/// the video, which costs less; by default the output follows the video's resolution.
///
/// {@endtemplate}
class VideoController {
  /// {@macro video_controller}
  VideoController(this.player, {this.configuration = const VideoConfiguration()})
      : _width = configuration.width,
        _height = configuration.height {
    player.isVideoControllerAttached = true;
    _create();
  }

  /// The [Player] whose video this controller renders.
  final Player player;

  /// The options this controller was created with.
  final VideoConfiguration configuration;

  /// The ID of the texture the video is rendered into, once the native output exists.
  final id = ValueNotifier<int?>(null);

  /// The size of the video output, once the native output exists.
  final rect = ValueNotifier<Rect?>(null);

  /// Completes when the native video output exists, or with the error that kept it from being created.
  Future<void> get ready => _ready.future;

  /// Completes when the first video frame has been rendered.
  Future<void> get waitUntilFirstFrameRendered => _firstFrame.future;

  final _ready = Completer<void>();

  final _firstFrame = Completer<void>();

  /// The size the output is fixed to, or null to follow the video.
  int? _width;

  int? _height;

  /// The video's own size, from [VideoParams].
  int? _videoWidth;

  int? _videoHeight;

  /// Keeps resizes from the video and from [setSize] in order.
  final _lock = Lock();

  StreamSubscription<VideoParams>? _subscription;

  /// Sets the size of the video output; a small size may cost much less. Without [width] and [height], the output
  /// follows the video's resolution again.
  Future<void> setSize({int? width, int? height}) async {
    await ready;
    if (_width == width && _height == height) {
      return;
    }

    _width = width;
    _height = height;
    if (width != null && height != null) {
      await _resize(width.toString(), height.toString());
      return;
    }

    await _resize(_videoWidth?.toString() ?? 'null', _videoHeight?.toString() ?? 'null');
  }

  Future<void> _create() async {
    // The native side needs the first frame of the widget tree.
    final frame = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => frame.complete());
    await frame.future;

    try {
      final handle = await player.handle;
      final first = _controllers[handle];
      if (first == null) {
        await _start(handle);
      } else {
        // A player has one video output; another controller for it shows the same texture.
        void mirror() {
          id.value = first.id.value;
          rect.value = first.rect.value;
        }

        mirror();
        first.id.addListener(mirror);
        first.rect.addListener(mirror);
        player.release.add(() async {
          first.id.removeListener(mirror);
          first.rect.removeListener(mirror);
        });
      }

      _ready.complete();
    } catch (exception, stacktrace) {
      _ready.completeError(exception);
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }

    if (!player.videoControllerCompleter.isCompleted) {
      player.videoControllerCompleter.complete();
    }
  }

  /// Creates the native video output for the player with this [handle] and waits for its first texture ID.
  Future<void> _start(int handle) async {
    _controllers[handle] = this;
    player.release.add(_dispose);
    _subscription = player.stream.videoParams.listen((params) => _lock.synchronized(() => _follow(params)));

    // Order matters: the video output must be set before the decoder.
    await player.setProperty('vo', configuration.vo, waitForInitialization: false);
    await player.setProperty('hwdec', configuration.hwdec, waitForInitialization: false);
    await player.setProperty('vid', 'auto', waitForInitialization: false);

    // Waiting on the native side would block the UI thread, so the texture ID arrives through the channel.
    final created = Completer<void>();

    void listener() {
      if (id.value != null && !created.isCompleted) {
        created.complete();
      }
    }

    id.addListener(listener);
    await _channel.invokeMethod('VideoOutputManager.Create', {
      'handle': handle.toString(),
      'configuration': {
        'width': configuration.width.toString(),
        'height': configuration.height.toString(),
        'enableHardwareAcceleration': configuration.enableHardwareAcceleration,
      },
    });
    await created.future;
    id.removeListener(listener);
  }

  /// Resizes the output to the video's new size, unless the output has a fixed size.
  Future<void> _follow(VideoParams params) async {
    if ([0, null].contains(params.dw)) {
      return;
    }

    if ([0, null].contains(params.dh)) {
      return;
    }

    // Width and height swap when the video is rotated by 90 or 270 degrees.
    final turned = params.rotate == 90 || params.rotate == 270;
    final width = turned ? params.dh! : params.dw!;
    final height = turned ? params.dw! : params.dh!;
    if (_videoWidth == width && _videoHeight == height) {
      return;
    }

    _videoWidth = width;
    _videoHeight = height;
    await _resize(width.toString(), height.toString());
  }

  Future<void> _resize(String width, String height) async {
    await _channel.invokeMethod('VideoOutputManager.SetSize', {
      'handle': (await player.handle).toString(),
      'width': width,
      'height': height,
    });
  }

  Future<void> _dispose() async {
    id.dispose();
    rect.dispose();
    await _subscription?.cancel();

    final handle = await player.handle;
    _controllers.remove(handle);
    await _channel.invokeMethod('VideoOutputManager.Dispose', {'handle': handle.toString()});
  }

  /// The controller that owns the native output of each player, by player handle.
  static final _controllers = HashMap<int, VideoController>();

  /// The native side reports each new texture and its size here.
  static final _channel = const MethodChannel('media_gears/video')
    ..setMethodCallHandler((call) async {
      if (call.method != 'VideoOutput.Resize') {
        return;
      }

      final controller = _controllers[call.arguments['handle']];
      if (controller == null) {
        return;
      }

      final Map rect = call.arguments['rect'];
      controller.rect.value = Rect.fromLTWH(
        rect['left'] * 1.0,
        rect['top'] * 1.0,
        rect['width'] * 1.0,
        rect['height'] * 1.0,
      );
      controller.id.value = call.arguments['id'];
      if (rect['width'] <= 0) {
        return;
      }

      if (rect['height'] <= 0) {
        return;
      }

      if (!controller._firstFrame.isCompleted) {
        controller._firstFrame.complete();
      }
    });
}

/// {@template video_controller_configuration}
///
/// VideoConfiguration
/// ----------------------------
/// Options for the video output of a [VideoController].
///
/// {@endtemplate}
class VideoConfiguration {
  /// {@macro video_controller_configuration}
  const VideoConfiguration({
    this.vo = 'libmpv',
    this.hwdec = 'auto',
    this.width,
    this.height,
    this.enableHardwareAcceleration = true,
  });

  /// mpv's [`--vo`](https://mpv.io/manual/stable/#options-vo) option.
  final String vo;

  /// mpv's [`--hwdec`](https://mpv.io/manual/stable/#options-hwdec) option.
  final String hwdec;

  /// A fixed width for the video output, or null to follow the video.
  final int? width;

  /// A fixed height for the video output, or null to follow the video.
  final int? height;

  /// Whether the output is rendered on the GPU. Without it the CPU renders, which costs much more.
  final bool enableHardwareAcceleration;

  /// Returns a copy with the given fields replaced.
  VideoConfiguration copyWith({
    String? vo,
    String? hwdec,
    int? width,
    int? height,
    bool? enableHardwareAcceleration,
  }) =>
      VideoConfiguration(
        vo: vo ?? this.vo,
        hwdec: hwdec ?? this.hwdec,
        width: width ?? this.width,
        height: height ?? this.height,
        enableHardwareAcceleration: enableHardwareAcceleration ?? this.enableHardwareAcceleration,
      );
}
