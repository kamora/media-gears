// Derived from media_kit (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:safe_local_storage/safe_local_storage.dart';

/// {@template asset_loader}
///
/// AssetLoader
/// -----------
///
/// A utility to load Flutter assets.
///
/// {@endtemplate}
class AssetLoader {
  static String load(String uri) {
    final key = encodeAssetKey(uri);
    final folder = path.dirname(Platform.resolvedExecutable);

    // macOS bundles the assets in App.framework; Windows and Linux keep them next to the executable.
    final asset = path.normalize(
      Platform.isMacOS
          ? path.join(folder, '..', 'Frameworks', 'App.framework', 'Resources', 'flutter_assets', key)
          : path.join(folder, 'data', 'flutter_assets', key),
    );
    if (!File(asset).existsSync_()) {
      throw Exception('Unable to load asset: $asset');
    }

    return asset;
  }

  static String encodeAssetKey(String uri) {
    String key = uri.split(_kAssetScheme).last;
    if (key.startsWith('/')) {
      key = key.substring(1);
    }

    // https://github.com/media-kit/media-kit/issues/121
    return key.split('/').map((e) => Uri.encodeComponent(e)).join('/');
  }

  /// URI scheme used to identify Flutter assets.
  static const String _kAssetScheme = 'asset://';
}
