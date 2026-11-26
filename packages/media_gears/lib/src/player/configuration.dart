/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

/// {@template player_configuration}
///
/// PlayerConfiguration
/// --------------------
/// Configurable options for customizing the [Player] behavior.
///
/// {@endtemplate}
class PlayerConfiguration {
  /// Sets the video output driver for native backend.
  ///
  /// Default: `null`.
  final String? vo;

  /// Enables on-screen controls for native backend.
  ///
  /// Default: `false`.
  final bool osc;

  /// Enables or disables pitch shift control for native backend.
  ///
  /// Enabling this option may result in de-syncing of audio & video.
  /// Thus, usage in audio only applications is recommended.
  /// This uses `scaletempo` under the hood & disables `audio-pitch-correction`.
  ///
  /// See: https://github.com/media-kit/media-kit/issues/45
  ///
  /// Default: `false`.
  final bool pitch;

  /// Sets the name of the underlying window & process for native backend.
  /// This is visible inside the Windows' volume mixer.
  ///
  /// Default: `null`.
  final String title;

  /// Optional callback invoked when the internals of the [Player] are initialized & ready for playback.
  ///
  /// Default: `null`.
  final void Function()? ready;

  /// Whether [Player] must be started in muted state.
  ///
  /// Default: `false`.
  final bool muted;

  /// Whether to use the async API for native backend.
  ///
  /// Default: `true`.
  final bool async;

  /// Whether to use [libass](https://github.com/libass/libass) based subtitle rendering for native backend.
  ///
  /// By default, subtitles rendering is Flutter `Widget` based.
  final bool libass;

  /// Sets the log level on native backend.
  /// Default: `none`.
  final LogLevel logLevel;

  /// Sets the demuxer cache size (in bytes) for native backend.
  ///
  /// Default: `32` MB or `32 * 1024 * 1024` bytes.
  final int bufferSize;

  /// Sets the list of allowed protocols for native backend.
  ///
  /// Default: `['file', 'tcp', 'tls', 'http', 'https', 'crypto', 'data']`.
  ///
  /// Learn more: https://ffmpeg.org/ffmpeg-protocols.html#Protocol-Options
  final List<String> protocolWhitelist;

  /// {@macro player_configuration}
  const PlayerConfiguration({
    this.vo = 'null',
    this.osc = false,
    this.pitch = false,
    this.title = 'package:media_gears',
    this.ready,
    this.muted = false,
    this.async = true,
    this.libass = false,
    this.logLevel = LogLevel.error,
    this.bufferSize = 32 * 1024 * 1024,
    this.protocolWhitelist = const [
      'udp',
      'rtp',
      'tcp',
      'tls',
      'data',
      'file',
      'http',
      'https',
      'crypto',
    ],
  });
}

/// {@template mpv_log_level}
///
/// LogLevel
/// --------------------
/// Options to customise the [Player] native backend log level.
///
/// {@endtemplate}
enum LogLevel {
  /// Disable absolutely all messages.
  /* none, */

  /// Critical/aborting errors.
  /* fatal, */

  // package:media_kit internally consumes logs of level error.

  /// Simple errors.
  error,

  /// Possible problems.
  warn,

  /// Informational message.
  info,

  /// Noisy informational message.
  v,

  /// Very noisy technical information.
  debug,

  /// Extremely noisy.
  trace,
}
