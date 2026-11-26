// Derived from media_kit (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the LICENSE file.

/// {@template audio_device}
///
/// AudioDevice
/// -----------
///
/// Represents an audio device which may be used for output in [Player].
///
/// {@endtemplate}
class AudioDevice {
  /// Name.
  final String name;

  /// Description.
  final String description;

  /// {@macro audio_device}
  const AudioDevice(
    this.name,
    this.description,
  );

  /// [AudioDevice] with automatic device selection.
  factory AudioDevice.auto() => const AudioDevice('auto', '');

  @override
  bool operator ==(Object other) {
    if (other is AudioDevice) {
      return other.name == name;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'AudioDevice($name, $description)';
}
