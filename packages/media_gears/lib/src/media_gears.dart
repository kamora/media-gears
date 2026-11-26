// Derived from media_kit (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:ffi';

import 'package:media_gears/src/ffi/ffi.dart';
import 'package:media_gears/src/generated/libmpv/bindings.dart';
import 'package:media_gears/src/player/core/native_library.dart';
import 'package:media_gears/src/player/utils/native_reference_holder.dart';

/// Sets up media_gears; call it once, before the first [Player] is created.
abstract class MediaGears {
  static bool _initialized = false;

  /// Loads libmpv, from [libmpv] when given, and quits the players a previous hot restart left running.
  static void ensureInitialized({String? libmpv}) {
    if (_initialized) {
      return;
    }

    try {
      NativeLibrary.ensureInitialized(libmpv: libmpv);
    } catch (_) {
      print('media_gears: libmpv could not be loaded. Run the app again after adding media_gears to pubspec.yaml; '
          'a hot restart does not load native libraries.');
      rethrow;
    }

    NativeReferenceHolder.ensureInitialized(_quit);
    _initialized = true;
  }

  /// Quits the mpv handles a hot restart left behind.
  static Future<void> _quit(List<Pointer<Void>> references) async {
    if (references.isEmpty) {
      return;
    }

    const tag = NativeReferenceHolder.kTag;
    print('$tag Found ${references.length} reference(s).');
    print('$tag Disposing:\n${references.map((e) => e.address).join('\n')}');

    // Clearing the wakeup callbacks first keeps mpv from calling Dart callbacks that no longer exist, which aborts
    // the app since Flutter 3.38; mpv_set_wakeup_callback is synchronous, so after it mpv never calls them again.
    // See https://github.com/media-kit/media-kit/issues/1314.
    final mpv = MPV(DynamicLibrary.open(NativeLibrary.path));
    for (final reference in references) {
      mpv.mpv_set_wakeup_callback(reference.cast(), nullptr, nullptr);
    }

    final quit = 'quit'.toNativeUtf8();
    try {
      for (final reference in references) {
        mpv.mpv_command_string(reference.cast(), quit.cast());
      }
    } finally {
      calloc.free(quit);
    }
  }
}
