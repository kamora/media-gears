import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:media_gears/media_gears.dart';
import 'package:path/path.dart' as path;

final sources = _Sources._();

/// The media the tests play: short clips made with FFmpeg, as files and over HTTP from a server in the test process.
class _Sources {
  _Sources._();

  List<String> get platform => file;

  /// The clips as files.
  final List<String> file = [];

  /// The clips over HTTP, sent at a limited rate so playback buffers as it does on a network.
  final List<String> network = [];

  final List<Uint8List> bytes = [];

  /// A clip of 12 seconds over HTTP, for seeking ahead of what has arrived.
  late final String long;

  /// test5.mkv from the Matroska test files over HTTP: 47 seconds with 8 subtitle tracks.
  late final String subtitles;

  /// The same, cut to its first 4 seconds with all its tracks.
  late final String tracks;

  /// A real HTTPS server, for the test that proves certificates are verified.
  final https = 'https://user-images.githubusercontent.com/28951144/229373709-603a7a89-2105-4e1b-a5a5-a6c3567c9a59.mp4';

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
    final address = await _serve(folder);

    // Four clips, each with its own tone, with a video and a stereo audio track like the videos they replace.
    for (var i = 0; i < 4; i++) {
      final name = 'clip-$i-${length.inSeconds}s.mp4';
      await _clip(folder, name, length.inSeconds, 440 + 110 * i);
      file.add(path.join(folder.path, name).replaceAll(r'\', '/'));
      network.add('$address/$name');
      bytes.add(await File(file.last).readAsBytes());
    }

    await _clip(folder, 'long-12s.mp4', 12, 330);
    long = '$address/long-12s.mp4';

    final full = File(path.join(folder.path, 'test5.mkv'));
    if (!await full.exists()) {
      await _ffmpeg([
        '-i',
        'https://github.com/ietf-wg-cellar/matroska-test-files/raw/master/test_files/test5.mkv',
        '-map',
        '0',
        '-c',
        'copy',
        full.path,
      ]);
    }

    final cut = File(path.join(folder.path, 'test5-4s.mkv'));
    if (!await cut.exists()) {
      await _ffmpeg(['-i', full.path, '-t', '${length.inSeconds}', '-map', '0', '-c', 'copy', cut.path]);
    }

    subtitles = '$address/test5.mkv';
    tracks = '$address/test5-4s.mkv';
    _prepared = true;
  }

  bool _prepared = false;

  /// Makes a clip of [seconds] with a test picture and a tone of [frequency], unless it is there already.
  Future<void> _clip(Directory folder, String name, int seconds, int frequency) async {
    final clip = File(path.join(folder.path, name));
    if (await clip.exists()) {
      return;
    }

    await _ffmpeg([
      '-f',
      'lavfi',
      '-i',
      'testsrc2=size=320x240:rate=25:duration=$seconds',
      '-f',
      'lavfi',
      '-i',
      'sine=frequency=$frequency:sample_rate=44100:duration=$seconds',
      '-c:v',
      'libx264',
      '-pix_fmt',
      'yuv420p',
      '-c:a',
      'aac',
      '-ac',
      '2',
      '-shortest',
      clip.path,
    ]);
  }

  Future<void> _ffmpeg(List<String> arguments) async {
    final result = await Process.run('ffmpeg', ['-y', '-v', 'error', ...arguments]);
    if (result.exitCode != 0) {
      throw StateError('FFmpeg failed: ${result.stderr}');
    }
  }

  /// Serves the files in [folder] over HTTP on a free port, with byte ranges for seeking, and returns its address.
  Future<String> _serve(Directory folder) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      final response = request.response;
      try {
        final file = File(path.join(folder.path, path.basename(request.uri.path)));
        final size = await file.length();
        var start = 0;
        var end = size - 1;
        final range = RegExp(r'bytes=(\d+)-(\d*)').firstMatch(request.headers.value(HttpHeaders.rangeHeader) ?? '');
        if (range != null) {
          start = int.parse(range.group(1)!);
          if (range.group(2)!.isNotEmpty) {
            end = int.parse(range.group(2)!);
          }

          response.statusCode = HttpStatus.partialContent;
          response.headers.set(HttpHeaders.contentRangeHeader, 'bytes $start-$end/$size');
        }

        response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        response.contentLength = end - start + 1;

        // The clips go at about 256 KB a second, in pieces of 16 KB: enough to play them, slow enough that opening
        // and seeking wait for data. The Matroska files, only for tracks and subtitles, go at full speed.
        if (!file.path.endsWith('.mp4')) {
          await response.addStream(file.openRead(start, end + 1));
          await response.close();
          return;
        }

        await for (final chunk in file.openRead(start, end + 1)) {
          for (var i = 0; i < chunk.length; i += 16384) {
            response.add(chunk.sublist(i, (i + 16384).clamp(0, chunk.length)));
            await response.flush();
            await Future.delayed(const Duration(milliseconds: 62));
          }
        }

        await response.close();
      } catch (_) {
        // mpv drops a connection whenever it seeks; the request just ends.
      }
    });

    return 'http://${server.address.address}:${server.port}';
  }
}

/// Waits until [player] has played its playlist to the end, and the events that follow the end have arrived.
Future<void> untilEnd(Player player) async {
  bool last() => player.state.playlist.index == player.state.playlist.medias.length - 1;
  if (!player.state.completed || !last()) {
    await player.stream.completed.firstWhere((completed) => completed && last());
  }

  await Future.delayed(const Duration(milliseconds: 500));
}
