import 'dart:io';
import 'dart:typed_data';

import 'package:media_gears/media_gears.dart';
import 'package:path/path.dart' as path;

final sources = _Sources._();

/// The media the tests play: short clips made with FFmpeg, and videos on the network for the tests about streaming.
class _Sources {
  _Sources._();

  List<String> get platform => file;

  final List<String> network = [
    'https://user-images.githubusercontent.com/28951144/229373709-603a7a89-2105-4e1b-a5a5-a6c3567c9a59.mp4',
    'https://user-images.githubusercontent.com/28951144/229373716-76da0a4e-225a-44e4-9ee7-3e9006dbc3e3.mp4',
    'https://user-images.githubusercontent.com/28951144/229373718-86ce5e1d-d195-45d5-baa6-ef94041d0b90.mp4',
    'https://user-images.githubusercontent.com/28951144/229373720-14d69157-1a56-4a78-a2f4-d7a134d7c3e9.mp4',
  ];

  final List<String> file = [];

  final List<Uint8List> bytes = [];

  /// How long each clip plays.
  static const length = Duration(seconds: 4);

  /// Upstream's waits were chosen for videos of 15 seconds; this is the same share of a clip.
  Duration scaled(num seconds) => length * (seconds / 15);

  Future<void> prepare() async {
    if (_prepared) {
      return;
    }

    final folder = Directory(path.join(Directory.systemTemp.path, 'media_gears'));
    await folder.create(recursive: true);

    // Four clips, each with its own tone, with a video and a stereo audio track like the videos they replace.
    for (var i = 0; i < 4; i++) {
      final clip = path.join(folder.path, 'clip-$i-${length.inSeconds}s.mp4').replaceAll(r'\', '/');
      if (!await File(clip).exists()) {
        final seconds = length.inSeconds;
        final result = await Process.run('ffmpeg', [
          '-y',
          '-v',
          'error',
          '-f',
          'lavfi',
          '-i',
          'testsrc2=size=320x240:rate=25:duration=$seconds',
          '-f',
          'lavfi',
          '-i',
          'sine=frequency=${440 + 110 * i}:sample_rate=44100:duration=$seconds',
          '-c:v',
          'libx264',
          '-pix_fmt',
          'yuv420p',
          '-c:a',
          'aac',
          '-ac',
          '2',
          '-shortest',
          clip,
        ]);
        if (result.exitCode != 0) {
          throw StateError('FFmpeg could not make $clip: ${result.stderr}');
        }
      }

      file.add(clip);
      bytes.add(await File(clip).readAsBytes());
    }

    _prepared = true;
  }

  bool _prepared = false;
}

/// Waits until [player] has played its playlist to the end, and the events that follow the end have arrived.
Future<void> untilEnd(Player player) async {
  bool last() => player.state.playlist.index == player.state.playlist.medias.length - 1;
  if (!player.state.completed || !last()) {
    await player.stream.completed.firstWhere((completed) => completed && last());
  }

  await Future.delayed(const Duration(milliseconds: 500));
}
